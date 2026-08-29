// Ghostty 1.3.1 用 Neovide 風カーソルシェーダー. (ChatGPT が作成)

// --- 用語・概念 -----------------------------------------------------------
//
// tail:
//   移動方向の後方に残る伸びた部分全体.
//
// main tail / tail tip:
//   rear 側 2 頂点のうち, 最も遅れて追従する主頂点.
//
// shoulder:
//   main tail と対になるもう 1 つの rear 頂点.
//   main tail より先に追従させることで tail の後端形状を作る.
//
// lag:
//   アニメーション開始直後, tail を意図的に取り残す区間.
//
// chase:
//   lag の後, tail が現在カーソルへ追いつく区間.
//
// settle:
//   chase の後, tail が最終位置へゆっくり合流する終盤区間.
//
// progress:
//   直前位置を 0.0, 現在位置を 1.0 とした補間位置.
//
// rear / front:
//   travel direction を基準にした後方 / 前方.
//   rear 側の頂点を遅らせ, front 側は現在カーソルに追従させる.
//

// --- 調整値 ---------------------------------------------------------------

// カーソル移動からアニメーション完了までの秒数.
// [0.0 < DURATION]
// 小さいほど全体が速く, 大きいほどゆっくり動く.
const float DURATION = 0.15;

// 完全な横移動でアニメーションを開始する最小移動距離をセル単位で指定する.
// [0.0 <= HORIZONTAL_THRESHOLD_CELLS]
// 0.0 なら 1 セル移動を含むすべての横移動で tail を表示する.
// 大きくすると短い横移動では tail を出さなくなる.
const float HORIZONTAL_THRESHOLD_CELLS = 4.0;

// 横移動とみなす Y 方向の最大移動量を pixel 単位で指定する.
// [0.0 < HORIZONTAL_Y_TOLERANCE_PX]
// 小さくすると僅かな Y 移動でも斜め移動として扱われる.
// 大きくすると多少 Y がずれていても横移動として扱われる.
const float HORIZONTAL_Y_TOLERANCE_PX = 0.5;

// tail 輪郭のアンチエイリアス幅を pixel 単位で指定する.
// [0.0 < EDGE_SOFTNESS_PX]
// 0.0 に近いほど硬い輪郭になり, 大きいほど境界が柔らかくなる.
const float EDGE_SOFTNESS_PX = 0.85;

// tail の不透明度.
// [0.0 <= EFFECT_OPACITY <= 1.0]
// 0.0 で不可視, 1.0 で最も濃くなる. 形状や動きには影響しない.
const float EFFECT_OPACITY = 0.985;

// settle 区間のうち, 特に強く減速させる最後の距離をセル単位で指定する.
// [0.0 < SETTLE_SLOW_RANGE_CELLS]
// 大きいほど早い地点から強い減速が始まり,
// 小さいほど終端近くまで速く追従する.
const float SETTLE_SLOW_RANGE_CELLS = 1.0;

// settle 終盤の減速カーブの強さ.
// [0.0 < SETTLE_POWER]
// 1.0 では追加の偏りがほぼなく,
// 1.0 より大きいほど終端直前で強く粘る.
// 1.0 より小さい値も使用できるが, 終端へ早く寄る動きになる.
const float SETTLE_POWER = 2.8;

// lag 区間が終了する時刻を, アニメーション全体の割合で指定する.
// [0.0 < TAIL_LAG_END_TIME < TAIL_CHASE_END_TIME < 1.0]
// 大きくすると tail が取り残される時間が長くなる.
const float TAIL_LAG_END_TIME = 0.14;

// chase 区間が終了して settle に入る時刻を指定する.
// [TAIL_LAG_END_TIME < TAIL_CHASE_END_TIME < 1.0]
// 大きくすると chase が長く続き, settle の時間が短くなる.
// 小さくすると早めに settle へ移行する.
const float TAIL_CHASE_END_TIME = 0.40;

// lag 終了時点で main tail が移動全体のどこまで進んでいるかを指定する.
// [0.0 <= TAIL_LAG_END_PROGRESS <= TAIL_SETTLE_START_MIN]
// 小さいほど初動で強く取り残され, tail が長く伸びる.
// 大きいほど lag 中でも早く追従する.
const float TAIL_LAG_END_PROGRESS = 0.10;

// settle 開始時に残しておきたい距離をセル単位で指定する.
// [0.0 <= TAIL_SETTLE_REMAIN_CELLS]
// 大きいほど長い距離を settle に使い, 終盤の減速が目立つ.
// 実際の settle 開始位置は TAIL_SETTLE_START_MIN / MAX で制限される.
const float TAIL_SETTLE_REMAIN_CELLS = 1.25;

// settle 開始 progress の下限.
// [0.0 <= TAIL_SETTLE_START_MIN <= TAIL_SETTLE_START_MAX <= 1.0]
// 小さくすると短距離移動でも早めに settle へ入る.
const float TAIL_SETTLE_START_MIN = 0.70;

// settle 開始 progress の上限.
// [TAIL_SETTLE_START_MIN <= TAIL_SETTLE_START_MAX <= 1.0]
// 大きくすると長距離移動で chase がより長く続く.
const float TAIL_SETTLE_START_MAX = 0.96;

// shoulder が現在カーソルへ完全に到着する時刻.
// [0.0 < SHOULDER_ARRIVE_START_TIME < SHOULDER_ARRIVE_TIME <= 1.0]
// 小さくすると shoulder が早く消えて三角形寄りになり,
// 大きくすると shoulder が長く残って台形寄りになる.
const float SHOULDER_ARRIVE_TIME = 0.4;

// shoulder が main tail とは別に現在カーソルへ寄り始める時刻.
// [0.0 <= SHOULDER_ARRIVE_START_TIME < SHOULDER_ARRIVE_TIME]
// 小さくすると早く rear edge が縮み始め,
// 大きくすると台形の形を長く保つ.
const float SHOULDER_ARRIVE_START_TIME = 0.25;

// shoulder を main tail よりどれだけ先行させるかを progress 差で指定する.
// [0.0 <= SHOULDER_LEAD <= 1.0]
// 大きいほど rear edge が短くなって三角形寄り,
// 0.0 に近いほど 2 頂点が揃って台形寄りになる.
const float SHOULDER_LEAD = 0.1;

// --- 基本処理 -------------------------------------------------------------

// TL, TR, BR, BL の順.
// Ghostty の cursor.xy は左上で, shader 座標の +Y は上方向.
const vec2 CORNER_SIGN[4] = vec2[4](
    vec2(-1.0,  1.0),
    vec2( 1.0,  1.0),
    vec2( 1.0, -1.0),
    vec2(-1.0, -1.0)
);

float easeOutCubic(float t) {
    float x = 1.0 - clamp(t, 0.0, 1.0);
    return 1.0 - x * x * x;
}

float smootherStep(float t) {
    t = clamp(t, 0.0, 1.0);
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

vec2 cursorCenter(vec4 cursor) {
    return cursor.xy + vec2(cursor.z * 0.5, -cursor.w * 0.5);
}

vec2 cursorCorner(vec4 cursor, int index) {
    return cursorCenter(cursor) + CORNER_SIGN[index] * cursor.zw * 0.5;
}

float edgeDistance(vec2 p, vec2 a, vec2 b) {
    vec2 edge = b - a;
    vec2 relative = p - a;
    return (edge.x * relative.y - edge.y * relative.x) / max(length(edge), 1e-5);
}

float quadCoverage(vec2 p, vec2 q0, vec2 q1, vec2 q2, vec2 q3) {
    // 時計回りの quad では内側の signed distance が 0 以下になる.
    float outside = max(
        max(edgeDistance(p, q0, q1), edgeDistance(p, q1, q2)),
        max(edgeDistance(p, q2, q3), edgeDistance(p, q3, q0))
    );
    return 1.0 - smoothstep(0.0, EDGE_SOFTNESS_PX, outside);
}

bool insideCursor(vec2 p, vec4 cursor) {
    return p.x >= cursor.x
        && p.x <= cursor.x + cursor.z
        && p.y <= cursor.y
        && p.y >= cursor.y - cursor.w;
}


// --- アニメーション -------------------------------------------------------

float settleEase(float t, float distanceCells) {
    t = clamp(t, 0.0, 1.0);
    float slowStart = max(
        0.0,
        1.0 - SETTLE_SLOW_RANGE_CELLS / max(distanceCells, 1e-4)
    );

    if (t < slowStart) return t;

    float p = clamp(
        (t - slowStart) / max(1.0 - slowStart, 1e-4),
        0.0,
        1.0
    );
    return mix(slowStart, 1.0, smootherStep(pow(p, SETTLE_POWER)));
}

float tailTipProgress(float t, float distanceCells) {
    t = clamp(t, 0.0, 1.0);

    float settleStartProgress = clamp(
        1.0 - TAIL_SETTLE_REMAIN_CELLS / max(distanceCells, 1e-4),
        TAIL_SETTLE_START_MIN,
        TAIL_SETTLE_START_MAX
    );

    if (t < TAIL_LAG_END_TIME) {
        return TAIL_LAG_END_PROGRESS * smootherStep(t / TAIL_LAG_END_TIME);
    }

    if (t < TAIL_CHASE_END_TIME) {
        float p = (t - TAIL_LAG_END_TIME) / (TAIL_CHASE_END_TIME - TAIL_LAG_END_TIME);
        return mix(TAIL_LAG_END_PROGRESS, settleStartProgress, easeOutCubic(p));
    }

    float p = (t - TAIL_CHASE_END_TIME) / (1.0 - TAIL_CHASE_END_TIME);
    float settleDistanceCells = distanceCells * (1.0 - settleStartProgress);
    return mix(
        settleStartProgress,
        1.0,
        settleEase(p, settleDistanceCells)
    );
}

float tailShoulderProgress(float t, float tailProgress) {
    // shoulder を main tail より少し強く先行させ, rear edge を短くする.
    // 完全な三角形にはせず, 僅かに台形を残して太さを維持する.
    if (t >= SHOULDER_ARRIVE_TIME) return 1.0;

    float base = min(1.0, tailProgress + SHOULDER_LEAD);
    if (t <= SHOULDER_ARRIVE_START_TIME) return base;

    float p = (t - SHOULDER_ARRIVE_START_TIME) / (SHOULDER_ARRIVE_TIME - SHOULDER_ARRIVE_START_TIME);
    return mix(base, 1.0, smootherStep(p));
}


// --- カーソル色 -----------------------------------------------------------

vec3 sampleScreen(vec2 p) {
    vec2 clamped = clamp(p, vec2(0.5), iResolution.xy - vec2(0.5));
    return texture(iChannel0, clamped / iResolution.xy).rgb;
}

// Ghostty 1.3.1 では cursor color の uniform が実際の描画色より明るくなる場合がある.
// そのため iCurrentCursorColor は使わず, 描画済み cursor から 5 点を取得して色を推定する.
// 文字の反転色を拾う可能性があるため単純な平均は使わず,
// 5 色の中で他の色との距離の合計が最も小さい medoid を effect color として採用する.
vec3 sampleCursorColor(vec4 cursor) {
    vec2 topLeft = cursor.xy;
    vec2 size = max(cursor.zw, vec2(1.0));
    vec2 inset = clamp(size * 0.28, vec2(0.75), vec2(3.0));

    vec3 samples[5] = vec3[5](
        sampleScreen(topLeft + vec2(inset.x, -inset.y)),
        sampleScreen(topLeft + vec2(size.x - inset.x, -inset.y)),
        sampleScreen(topLeft + vec2(size.x - inset.x, -(size.y - inset.y))),
        sampleScreen(topLeft + vec2(inset.x, -(size.y - inset.y))),
        sampleScreen(topLeft + vec2(size.x * 0.5, -size.y * 0.5))
    );

    float bestScore = 1e30;
    vec3 best = samples[0];

    for (int i = 0; i < 5; ++i) {
        float score = 0.0;
        for (int j = 0; j < 5; ++j) {
            vec3 diff = samples[i] - samples[j];
            score += dot(diff, diff);
        }
        if (score < bestScore) {
            bestScore = score;
            best = samples[i];
        }
    }

    return best;
}


// --- カーソル変形 ---------------------------------------------------------

void trailingCorners(
    vec2 travelDirection,
    out int tailCorner,
    out int shoulderCorner
) {
    const float AXIS_EPSILON = 1e-4;

    if (abs(travelDirection.y) < AXIS_EPSILON) {
        // Ghostty 上での実際の見え方に合わせる.
        // 完全な横移動では, main tail を常に上側にする.
        if (travelDirection.x > 0.0) {
            tailCorner = 3;
            shoulderCorner = 0;
        } else {
            tailCorner = 2;
            shoulderCorner = 1;
        }
        return;
    }

    if (abs(travelDirection.x) < AXIS_EPSILON) {
        // 完全な縦移動では, 進行方向を前とした右後ろを main tail にする.
        if (travelDirection.y > 0.0) {
            tailCorner = 3;
            shoulderCorner = 2;
        } else {
            tailCorner = 1;
            shoulderCorner = 0;
        }
        return;
    }

    // 斜めでは進行方向への射影が小さい順に rear の 2 頂点を選ぶ.
    float firstScore = 1e30;
    float secondScore = 1e30;
    tailCorner = 0;
    shoulderCorner = 1;

    for (int i = 0; i < 4; ++i) {
        float score = dot(CORNER_SIGN[i], travelDirection);

        if (score < firstScore) {
            secondScore = firstScore;
            shoulderCorner = tailCorner;
            firstScore = score;
            tailCorner = i;
        } else if (score < secondScore) {
            secondScore = score;
            shoulderCorner = i;
        }
    }
}


// --- メイン ---------------------------------------------------------------

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 base = texture(iChannel0, fragCoord / iResolution.xy);
    fragColor = base;

    // Ghostty 1.3.1 では style, visibility, focus は int.
    if (iFocus == 0 || iCursorVisible == 0) return;
    if (iCurrentCursorStyle != CURSORSTYLE_BLOCK) return;

    float elapsed = max(iTime - iTimeCursorChange, 0.0);
    if (elapsed >= DURATION) return;

    vec2 oldCenter = cursorCenter(iPreviousCursor);
    vec2 newCenter = cursorCenter(iCurrentCursor);
    vec2 delta = newCenter - oldCenter;
    float distancePx = length(delta);

    if (distancePx < 1e-4) return;

    vec2 cellSize = max(iCurrentCursor.zw, vec2(1.0));

    // 純粋な横移動だけしきい値を設け, 縦 / 斜め移動は常に対象にする.
    if (
        abs(delta.y) < HORIZONTAL_Y_TOLERANCE_PX
        && abs(delta.x) < cellSize.x * HORIZONTAL_THRESHOLD_CELLS
    ) {
        return;
    }

    vec2 travelDirection = delta / distancePx;
    float t = clamp(elapsed / DURATION, 0.0, 1.0);
    float distanceCells = length(delta / cellSize);

    float tailProgress = tailTipProgress(t, distanceCells);
    float shoulderProgress = tailShoulderProgress(t, tailProgress);

    int tailCorner;
    int shoulderCorner;
    trailingCorners(travelDirection, tailCorner, shoulderCorner);

    // current cursor を基準に, rear の 2 頂点だけ previous 側へ遅らせる.
    vec2 quad[4];
    for (int i = 0; i < 4; ++i) {
        quad[i] = cursorCorner(iCurrentCursor, i);
    }

    quad[tailCorner] = mix(
        cursorCorner(iPreviousCursor, tailCorner),
        quad[tailCorner],
        tailProgress
    );
    quad[shoulderCorner] = mix(
        cursorCorner(iPreviousCursor, shoulderCorner),
        quad[shoulderCorner],
        shoulderProgress
    );

    bool diagonalMove =
        abs(travelDirection.x) > 1e-4
        && abs(travelDirection.y) > 1e-4;

    if (diagonalMove) {
        // 軸平行長方形の support point は解析的に得られる.
        // 4 corner の射影探索に戻すと同じ結果を余計な処理で求めることになる.
        vec2 normal = vec2(-travelDirection.y, travelDirection.x);
        vec2 extent = iCurrentCursor.zw * 0.5 * sign(normal);
        vec2 tailPoint = quad[tailCorner];
        vec2 shoulderPoint = quad[shoulderCorner];

        float tailOffset = dot(tailPoint - newCenter, normal);
        float shoulderOffset = dot(shoulderPoint - newCenter, normal);

        quad[0] = newCenter + extent;
        quad[1] = newCenter - extent;

        if (tailOffset < shoulderOffset) {
            quad[2] = tailPoint;
            quad[3] = shoulderPoint;
        } else {
            quad[2] = shoulderPoint;
            quad[3] = tailPoint;
        }
    }

    float coverage = quadCoverage(
        fragCoord,
        quad[0],
        quad[1],
        quad[2],
        quad[3]
    );

    // 実 cursor は Ghostty の描画を残し, trail 部分だけ上書きする.
    if (coverage <= 0.0 || insideCursor(fragCoord, iCurrentCursor)) return;

    vec3 cursorColor = sampleCursorColor(iCurrentCursor);
    float alpha = coverage * EFFECT_OPACITY;

    fragColor.rgb = mix(base.rgb, cursorColor, alpha);
    fragColor.a = base.a;
}
