program CollectionsTests;
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
  Tests.Base in 'Tests.Base.pas',
  Tests.Bag in 'Tests.Bag.pas',
  Tests.BidiMap in 'Tests.BidiMap.pas',
  Tests.Dictionary in 'Tests.Dictionary.pas',
  Tests.DistinctMultiMap in 'Tests.DistinctMultiMap.pas',
  Tests.DoubleSortedBidiMap in 'Tests.DoubleSortedBidiMap.pas',
  Tests.DoubleSortedDistinctMultiMap in 'Tests.DoubleSortedDistinctMultiMap.pas',
  Tests.DoubleSortedMultiMap in 'Tests.DoubleSortedMultiMap.pas',
  Tests.HashSet in 'Tests.HashSet.pas',
  Tests.LinkedList in 'Tests.LinkedList.pas',
  Tests.LinkedQueue in 'Tests.LinkedQueue.pas',
  Tests.LinkedStack in 'Tests.LinkedStack.pas',
  Tests.List in 'Tests.List.pas',
  Tests.LinkedDictionary in 'Tests.LinkedDictionary.pas',
  Tests.LinkedSet in 'Tests.LinkedSet.pas',
  Tests.MultiMap in 'Tests.MultiMap.pas',
  Tests.PriorityQueue in 'Tests.PriorityQueue.pas',
  Tests.Queue in 'Tests.Queue.pas',
  Tests.SortedBag in 'Tests.SortedBag.pas',
  Tests.SortedBidiMap in 'Tests.SortedBidiMap.pas',
  Tests.SortedDictionary in 'Tests.SortedDictionary.pas',
  Tests.SortedDistinctMultiMap in 'Tests.SortedDistinctMultiMap.pas',
  Tests.SortedList in 'Tests.SortedList.pas',
  Tests.SortedMultiMap in 'Tests.SortedMultiMap.pas',
  Tests.SortedSet in 'Tests.SortedSet.pas',
  Tests.Stack in 'Tests.Stack.pas',
  Tests.Utils in 'Tests.Utils.pas',
  Tests.Enex in 'Tests.Enex.pas',
  Tests.SortedLinkedList in 'Tests.SortedLinkedList.pas';

{$R *.RES}

begin
  Application.Initialize;
  if IsConsole then
    with TextTestRunner.RunRegisteredTests do
      Free
  else
    GUITestRunner.RunRegisteredTests;
end.

