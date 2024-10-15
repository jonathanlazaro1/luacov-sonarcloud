echo "Running tests"
lua -lluacov example/test_calculator.lua
echo "Creating SonarCloud report"
./bin/luacov-sonarcloud luacov.stats.out -o example.xml
