local luacov_reporter = require("luacov.reporter")
local xml2lua = require("xml2lua")

local ReporterBase = luacov_reporter.ReporterBase

-- ReporterBase provide
--  write(str) - write string to output file
--  config()   - return configuration table

local sonarcloud_reporter = setmetatable({}, ReporterBase) do
sonarcloud_reporter.__index = sonarcloud_reporter

function sonarcloud_reporter:new(conf)
	local o, err = ReporterBase.new(sonarcloud_reporter, conf)
	if not o then
		return nil, err
	end

	if conf.sonarcloud.filenameparser then
		local parsed_data = {}
		local files = {}
		for filename,stats in pairs(o._data) do
			local parsed_filename = conf.sonarcloud.filenameparser(filename)
			if parsed_data[parsed_filename] == nil or parsed_data[parsed_filename].max < stats.max then
				parsed_data[parsed_filename] = stats
				table.insert(files, parsed_filename)
			end
		end
		o._data = parsed_data
		o._files = files
	end

	return o
end

function sonarcloud_reporter:on_start()
	sonarcloud_reporter.coverage = { _attr={ version = "1" }, file = {} }
end

function sonarcloud_reporter:on_new_file(filename)
	local file = { _attr= { path = filename }, lineToCover = {} }

	sonarcloud_reporter.current_file = file
	table.insert(sonarcloud_reporter.coverage.file, file)
end

function sonarcloud_reporter:on_empty_line(filename, lineno, line)
end

function sonarcloud_reporter:on_mis_line(filename, lineno, line)
	table.insert(sonarcloud_reporter.current_file.lineToCover, { _attr = { lineNumber = lineno, covered = "false" } })
end

function sonarcloud_reporter:on_hit_line(filename, lineno, line, hits)
	table.insert(sonarcloud_reporter.current_file.lineToCover, { _attr = { lineNumber = lineno, covered = "true" } })
end

--- Handle when a file has been completely parsed from start to end
-- @param filename
-- @param hits
-- @param miss
function sonarcloud_reporter:on_end_file(filename, hits, miss)
end

--- Handle when the entire report has been completely parsed
function sonarcloud_reporter:on_end()
	local xml = xml2lua.toXml(sonarcloud_reporter.coverage, "coverage")
	self:write(xml)
end

end

local reporter = {}

function reporter.report()
	return luacov_reporter.report(sonarcloud_reporter)
end

return reporter
