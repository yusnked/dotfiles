local M = {}

function M.abbrev(...)
    return require("self.lib.path.abbrev").abbrev(...)
end

function M.abbrev_with_projects(...)
    return require("self.lib.path.abbrev").abbrev_with_projects(...)
end

return M
