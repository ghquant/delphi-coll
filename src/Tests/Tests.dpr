program Tests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  Tests.Conformance.Base in 'Tests.Conformance.Base.pas',
  Tests.Conformance.Lists in 'Tests.Conformance.Lists.pas',
  Tests.Conformance.Stacks in 'Tests.Conformance.Stacks.pas',
  Tests.Conformance.Queues in 'Tests.Conformance.Queues.pas',
  Tests.Conformance.Sets in 'Tests.Conformance.Sets.pas',
  Tests.Conformance.Dictionaries in 'Tests.Conformance.Dictionaries.pas',
  Tests.Conformance.BidiDictionaries in 'Tests.Conformance.BidiDictionaries.pas',
  Tests.Conformance.MultiMaps in 'Tests.Conformance.MultiMaps.pas',
  Tests.Conformance.BidiMaps in 'Tests.Conformance.BidiMaps.pas',
  Tests.Conformance.Bags in 'Tests.Conformance.Bags.pas',
  Tests.Internal.Basics in 'Tests.Internal.Basics.pas',
  Tests.Internal.Serialization in 'Tests.Internal.Serialization.pas',
  Tests.Internal.Dynamic in 'Tests.Internal.Dynamic.pas',
  Tests.Conformance.Specific in 'Tests.Conformance.Specific.pas';

{$R *.RES}


begin
  Application.Initialize;

  if IsConsole then
    with TextTestRunner.RunRegisteredTests do
      Free
  else
    GUITestRunner.RunRegisteredTests;
end.

