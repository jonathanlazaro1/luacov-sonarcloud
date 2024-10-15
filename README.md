# luacov-sonarcloud

LuaCov to SonarCloud generic report generator, inspired on (and forked from) [luacov-cobertura](https://github.com/britzl/luacov-cobertura). The current output report format is extracted from [here](https://docs.sonarsource.com/sonarcloud/enriching/test-coverage/generic-test-data/).

## Usage

- Run `luacov-sonarcloud`

### Command line arguments

```
luacov-sonarcloud [-h] [-c FILE] [-o FILE]

optional arguments:
  -h            show this help message and exit
  -c FILE       configuration file
  -o FILE       output file
```

### SonarCloud specific configuration

The configuration file may contain a sonarcloud.filenameparser function that can be used to manipulate the filenames in the stat file:

```
local configuration = {
	-- standard luacov configuration keys and values here
	statsfile = "foobar",

	sonarcloud = {
		-- this function will be called for each filename in the stats file
		-- the function may be used to manipulate the path before the file is
		-- processed by the report generator
		filenameparser = function(filename)
			-- do stuff with the filename here
			return filename .. "foobar"
		end,
	},
}
return configuration
```
