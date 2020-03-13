*** Settings ***
Documentation    https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#named-only-arguments
Library          Process
Library          ArgumentUtils.py

# To run:
# python -m robot -L debug -d Results/  Tests/named-arguments-tests.robot

*** Variables ***
${varName} =        arg1

*** Test Cases ***
(Test 1) Named Argument Syntax Used With A Keyword
    [Documentation]  When the named argument syntax is used with user keywords, the argument names must be
    ...              given without the ${} decoration. For example, user keyword with arguments
    ...              ${arg1}=first, ${arg2}=second must be used like arg2=override.
    Keyword With Named Arguments    arg2=override

(Test 2) Named arguments with variables
    [Documentation]  If the value is a single scalar variable, it is passed to the keyword as-is. This allows using
    ...              any objects, not only strings, as values also when using the named argument syntax. For example,
    ...              calling a keyword like arg=${object} will pass the variable ${object} to the keyword without
    ...              converting it to a string.
    ${lst} =         Create List    ${1}       ${2}     ${3}
    Keyword With Named Arguments    arg2=${lst}

(Test 3) Named arguments with variables
    [Documentation]  If variables are used in named argument names, those variables are resolved before matching
    ...              them against argument VALUES.
    ${lst} =         Create List    ${1}       ${2}     ${3}
    Keyword With Named Arguments    ${varName}=${lst}       # resolved to arg1=${lst}

(Test 4) Named arguments with variables
    [Documentation]  A variable alone can never trigger the named argument syntax, not even if
    ...              it has a value like foo=bar. This is important to remember especially when wrapping keywords
    ...              into other keywords. If, for example, a keyword takes a variable number of arguments like @{args}
    ...              and passes all of them to another keyword using the same @{args} syntax, possible named=arg syntax
    ...              used in the calling side is not recognized

    # TODO: Comment out the code below and see that it fails
    # Run Program (version one)      shell\=True       # This will NOT come as a named argument to Run Process, it will be passed as a string 'shell=True'
    Run Program (version two)       arg=${True}      # This WILL come as a named argument to Run Process
    Run Program (version three)     shell=${True}    # This WILL come as a named argument to Run Process

(Test 5) Named Arguments and Free Named Arguments
    [Documentation]  Free named arguments support variables similarly as named arguments. In practice that means that
    ...              variables can be used both in names and values, but the EQUAL sign must always be visible
    ...              literally. For example, both foo=${bar} and ${variable_one}=${variable_two} are valid,
    ...              as long as the variables that are used exist.
    ...              An extra limitation is that free argument names must always be strings
    ${variable_one}=        Set Variable   key3
    ${variable_two}=        Set Variable   value3
    &{d}=          Create Dictionary       key1=value1         key2=value2
    (Keyword 1) With Named Arguments And With Free Named Arguments       &{d}   ${variable_one}=${variable_two}

(Test 6) Positional Arguments, Named Arguments and Free Named Arguments
    [Documentation]  Refer to the examples in
    ...              https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#free-named-arguments
    Run Program    arg1    arg2    cwd=/home/user
    Run Program    argument    shell=${True}    env=${varName}

(Test 7) Named-only arguments with user keywords
    [Documentation]     Examples from here:
    ...                 https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#named-only-arguments-with-user-keywords
    With Varargs        named-only=value
    With Varargs        positional    second positional    named-only=foobar
    Without Varargs     first=1    second=2
    Without Varargs     second=toka    first=eka
    With Positional     foo    named-only=bar
    With Positional     named-only=2    positional=1
    With Free Named     item    named-only=value    x=1    y=2
    With Free Named     foo=a    bar=b    named-only=c    quux=d
    With Default
    With Default        named-only=overridden
    With And Without Defaults   mandatory=${1}      mandatory 2=${2}      optional 2=overridden   mandatory 3=${3}

*** Keywords ***
With Default
    [Arguments]    @{}    ${named-only}=default
    Log    ${named-only}

With And Without Defaults
    [Arguments]    @{}    ${optional}=default    ${mandatory}    ${mandatory 2}    ${optional 2}=default 2    ${mandatory 3}
    Log    ${optional}
    Log    ${mandatory}
    Log    ${mandatory 2}
    Log    ${optional 2}
    Log    ${mandatory 3}

With Varargs
    [Arguments]    @{varargs}    ${named-only}
    Log         ${varargs}
    Log         ${named-only}

Without Varargs
    [Arguments]    @{}    ${first}    ${second}
    Log     ${first}
    Log     ${second}

With Positional
    [Arguments]    ${positional}    @{}    ${named-only}
    Log     ${positional}
    Log     ${named-only}

With Free Named
    [Arguments]    @{varargs}    ${named-only}    &{free-named}
    Log     ${varargs}
    Log     ${named-only}
    Log     ${free-named}

Run Program
    [Arguments]  @{args}    &{config}
    Log     ${args}
    Log     ${config}
    My "Run Process"    program.py    @{args}    &{config}

Run Program (version one)
    [Arguments]     @{args}
    Log    ${args}
    Run Process     python /home/hakan/Python/Robot/arguments-in-robot/Tests/program.py

Run Program (version two)
    [Arguments]     ${arg}
    Log    ${arg}
    Run Process     python /home/hakan/Python/Robot/arguments-in-robot/Tests/program.py arg1     shell=${arg}

Run Program (version three)
    [Documentation]  If keyword needs to accept and pass forward any named arguments, it must be changed
    ...              to accept free named arguments. Compare it with "Run Program (version one/two)"
    [Arguments]      &{named}  # a free named argument
    Log    ${named}
    Run Process      python /home/hakan/Python/Robot/arguments-in-robot/Tests/program.py arg1     &{named}

Keyword With Named Arguments
    [Arguments]    ${arg1}=first   ${arg2}=second
    Log         ${arg1}
    Log         ${arg2}

(Keyword 1) With Named Arguments And With Free Named Arguments
    [Documentation]  free_named_args: the arguments that use the named argument syntax
    ...             (name=value) and do not match any arguments specified in the signature of the keyword

    [Arguments]    ${arg1}=first   ${arg2}=second   &{free_named_args}
    Log         ${arg1}
    Log         ${arg2}
    Log         ${free_named_args}
    FOR     ${item}     IN   @{free_named_args}
        Log     ${free_named_args}[${item}]
    END

