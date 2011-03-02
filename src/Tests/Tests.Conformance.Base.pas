(*
* Copyright (c) 2011, Ciobanu Alexandru
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * Neither the name of the <organization> nor the
*       names of its contributors may be used to endorse or promote products
*       derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE AUTHOR ''AS IS'' AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*)

unit Tests.Conformance.Base;
interface
uses SysUtils,
     TestFramework,
     Tests.Internal.Basics,
     Generics.Collections,
     Collections.Base;

type
  TOrdering = (oNone, oInsert, oAscending, oDescending);
  TElements = TArray<NativeInt>;
  TPairs = TArray<TPair<NativeInt, NativeInt>>;

  TConformance_IEnumerable_Simple = class(TTestCaseEx)
  strict private
    FEmpty, FOne, FFull: IEnumerable<NativeInt>;
    FElements: TElements;
    FOrdering: TOrdering;

  protected
    property Ordering: TOrdering read FOrdering;
    property Elements: TElements read FElements;

    procedure SetUp_IEnumerable(out AEmpty, AOne, AFull: IEnumerable<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); virtual; abstract;
    procedure SetUp; override;
    procedure TearDown; override;

  published
    procedure Test_GetEnumerator();
    procedure Test_Enumerator_Early_Current;
    procedure Test_Enumerator_ReachEnd;
  end;

  TConformance_ICollection_Simple = class(TConformance_IEnumerable_Simple)
  strict private
    FEmpty, FOne, FFull: ICollection<NativeInt>;

  protected
    procedure SetUp_IEnumerable(out AEmpty, AOne, AFull: IEnumerable<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
    procedure SetUp_ICollection(out AEmpty, AOne, AFull: ICollection<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); virtual; abstract;

  published
    procedure Test_Version();
    procedure Test_GetCount;
    procedure Test_Empty;
    procedure Test_Single;
    procedure Test_SingleOrDefault;
    procedure Test_CopyTo_1;
    procedure Test_CopyTo_2;
    procedure Test_ToArray;
  end;

  TConformance_IEnexCollection = class(TConformance_ICollection_Simple)
  strict private
    FEmpty, FOne, FFull: IEnexCollection<NativeInt>;

  protected
    procedure SetUp_ICollection(out AEmpty, AOne, AFull: ICollection<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
    procedure SetUp_IEnexCollection(out AEmpty, AOne, AFull: IEnexCollection<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); virtual; abstract;

  published
    procedure Test_EqualsTo;
    procedure Test_ToList;
    procedure Test_ToSet;
    procedure Test_Max;
    procedure Test_Min;
    procedure Test_First;
    procedure Test_FirstOrDefault;
    procedure Test_FirstWhere;
    procedure Test_FirstWhereOrDefault;
    procedure Test_FirstWhereNot;
    procedure Test_FirstWhereNotOrDefault;
    procedure Test_Last;
    procedure Test_LastOrDefault;
    procedure Test_Aggregate;
    procedure Test_AggregateOrDefault;
    procedure Test_ElementAt;
    procedure Test_ElementAtOrDefault;
    procedure Test_Any;
    procedure Test_All;
    procedure Test_Where;
    procedure Test_WhereNot;
    procedure Test_Distinct;
    procedure Test_Ordered_1;
    procedure Test_Ordered_2;
    procedure Test_Reversed;
    procedure Test_Concat;
    procedure Test_Union;
    procedure Test_Exclude;
    procedure Test_Intersect;
    procedure Test_Range;
    procedure Test_Take;
    procedure Test_TakeWhile;
    procedure Test_Skip;
    procedure Test_SkipWhile;
    procedure Test_Op_Select_1;
    procedure Test_Op_Select_2;
    procedure Test_Op_Select_3;
    procedure Test_Op_Select_4;
    procedure Test_Op_Select_5;
    procedure Test_Op_GroupBy;
  end;

  TConformance_IGrouping = class(TConformance_IEnexCollection)
  strict private
    FEmpty, FOne, FFull: IGrouping<NativeInt, NativeInt>;
    FKey: NativeInt;

  protected
    procedure SetUp_IEnexCollection(out AEmpty, AOne, AFull: IEnexCollection<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
    procedure SetUp_IGrouping(out AEmpty, AOne, AFull: IGrouping<NativeInt, NativeInt>; out AKey: NativeInt; out AElements: TElements; out AOrdering: TOrdering); virtual; abstract;

  published
    procedure Test_GetKey;
  end;

  TConformance_IOperableCollection = class(TConformance_IEnexCollection)
  strict private
    FEmpty, FOne, FFull: IOperableCollection<NativeInt>;

  protected
    procedure SetUp_IEnexCollection(out AEmpty, AOne, AFull: IEnexCollection<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
    procedure SetUp_IOperableCollection(out AEmpty, AOne, AFull: IOperableCollection<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); virtual; abstract;

  published
    procedure Test_Clear;
    procedure Test_Add;
    procedure Test_AddAll;
    procedure Test_Remove;
    procedure Test_RemoveAll;
    procedure Test_Contains;
    procedure Test_ContainsAll;
  end;

  TConformance_IStack = class(TConformance_IOperableCollection)
  strict private
    FEmpty, FOne, FFull: IStack<NativeInt>;

  protected
    procedure SetUp_IOperableCollection(out AEmpty, AOne, AFull: IOperableCollection<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
    procedure SetUp_IStack(out AEmpty, AOne, AFull: IStack<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); virtual; abstract;

  published
    procedure Test_Push;
    procedure Test_Pop;
    procedure Test_Peek;
  end;

  TConformance_IQueue = class(TConformance_IOperableCollection)
  strict private
    FEmpty, FOne, FFull: IQueue<NativeInt>;

  protected
    procedure SetUp_IOperableCollection(out AEmpty, AOne, AFull: IOperableCollection<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
    procedure SetUp_IQueue(out AEmpty, AOne, AFull: IQueue<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); virtual; abstract;

  published
    procedure Test_Enqueue;
    procedure Test_Dequeue;
    procedure Test_Peek;
  end;

  TConformance_ISet = class(TConformance_IOperableCollection)
  strict private
    FEmpty, FOne, FFull: ISet<NativeInt>;

  protected
    procedure SetUp_IOperableCollection(out AEmpty, AOne, AFull: IOperableCollection<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
    procedure SetUp_ISet(out AEmpty, AOne, AFull: ISet<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); virtual; abstract;

  published
  end;

  TConformance_ISortedSet = class(TConformance_ISet)
  strict private
    FEmpty, FOne, FFull: ISortedSet<NativeInt>;

  protected
    procedure SetUp_ISet(out AEmpty, AOne, AFull: ISet<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
    procedure SetUp_ISortedSet(out AEmpty, AOne, AFull: ISortedSet<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); virtual; abstract;

  published
    procedure Test_Max;
    procedure Test_Min;
  end;

  TConformance_IBag = class(TConformance_ISet)
  strict private
    FEmpty, FOne, FFull: IBag<NativeInt>;

  protected
    procedure SetUp_ISet(out AEmpty, AOne, AFull: ISet<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
    procedure SetUp_IBag(out AEmpty, AOne, AFull: IBag<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); virtual; abstract;

  published
    procedure Test_AddWeight;
    procedure Test_RemoveWeight;
    procedure Test_RemoveAllWeight;
    procedure Test_ContainsWeight;
    procedure Test_GetWeight;
    procedure Test_SetWeight;
  end;

  TConformance_IList = class(TConformance_IOperableCollection)
  strict private
    FEmpty, FOne, FFull: IList<NativeInt>;

  protected
    procedure SetUp_IOperableCollection(out AEmpty, AOne, AFull: IOperableCollection<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
    procedure SetUp_IList(out AEmpty, AOne, AFull: IList<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); virtual; abstract;

  published
    procedure Test_Insert;
    procedure Test_Insert_All;
    procedure Test_RemoveAt;
    procedure Test_ExtractAt;
    procedure Test_IndexOf_1;
    procedure Test_IndexOf_2;
    procedure Test_IndexOf_3;
    procedure Test_LastIndexOf_1;
    procedure Test_LastIndexOf_2;
    procedure Test_LastIndexOf_3;
    procedure Test_GetItem;
    procedure Test_SetItem;
  end;

  TConformance_ILinkedList = class(TConformance_IList)
  strict private
    FEmpty, FOne, FFull: ILinkedList<NativeInt>;

  protected
    procedure SetUp_IList(out AEmpty, AOne, AFull: IList<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
    procedure SetUp_ILinkedList(out AEmpty, AOne, AFull: ILinkedList<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); virtual; abstract;

  published
    procedure Test_AddLast;
    procedure Test_AddAllLast;
    procedure Test_AddFirst;
    procedure Test_AddAllFirst;
    procedure Test_RemoveFirst;
    procedure Test_RemoveLast;
    procedure Test_ExtractFirst;
    procedure Test_ExtractLast;
    procedure Test_First;
    procedure Test_Last;
  end;

  TConformance_IEnumerable_Associative = class(TTestCaseEx)
  strict private
    FEmpty, FOne, FFull: IEnumerable<TPair<NativeInt, NativeInt>>;
    FPairs: TPairs;
    FKeyOrdering: TOrdering;

  protected
    property KeyOrdering: TOrdering read FKeyOrdering;
    property Pairs: TPairs read FPairs;

    procedure SetUp_IEnumerable(out AEmpty, AOne, AFull: IEnumerable<TPair<NativeInt, NativeInt>>; out APairs: TPairs; out AKeyOrdering: TOrdering); virtual; abstract;
    procedure SetUp; override;
    procedure TearDown; override;

  published
    procedure Test_GetEnumerator();
    procedure Test_Enumerator_Early_Current;
    procedure Test_Enumerator_ReachEnd;
  end;

  TConformance_ICollection_Associative = class(TConformance_IEnumerable_Associative)
  strict private
    FEmpty, FOne, FFull: ICollection<TPair<NativeInt, NativeInt>>;

  protected
    procedure SetUp_IEnumerable(out AEmpty, AOne, AFull: IEnumerable<TPair<NativeInt, NativeInt>>; out APairs: TPairs; out AKeyOrdering: TOrdering); override;
    procedure SetUp_ICollection(out AEmpty, AOne, AFull: ICollection<TPair<NativeInt, NativeInt>>; out APairs: TPairs; out AKeyOrdering: TOrdering); virtual; abstract;

  published
    procedure Test_Version();
    procedure Test_GetCount;
    procedure Test_Empty;
    procedure Test_Single;
    procedure Test_SingleOrDefault;
    procedure Test_CopyTo_1;
    procedure Test_CopyTo_2;
    procedure Test_ToArray;
  end;

  TConformance_IEnexAssociativeCollection = class(TConformance_ICollection_Associative)
  strict private
    FEmpty, FOne, FFull: IEnexAssociativeCollection<NativeInt, NativeInt>;

  protected
    procedure SetUp_ICollection(out AEmpty, AOne, AFull: ICollection<TPair<NativeInt, NativeInt>>; out APairs: TPairs; out AKeyOrdering: TOrdering); override;
    procedure SetUp_IEnexAssociativeCollection(out AEmpty, AOne, AFull: IEnexAssociativeCollection<NativeInt, NativeInt>; out APairs: TPairs; out AKeyOrdering: TOrdering); virtual; abstract;

  published
    procedure Test_ToDictionary;
    procedure Test_ValueForKey;
    procedure Test_KeyHasValue;
    procedure Test_MaxKey;
    procedure Test_MinKey;
    procedure Test_MaxValue;
    procedure Test_MinValue;
    procedure Test_SelectKeys;
    procedure Test_SelectValues;
    procedure Test_DistinctByKeys;
    procedure Test_DistinctByValues;
    procedure Test_Includes;
    procedure Test_Where;
    procedure Test_WhereNot;
  end;

  TConformance_IMap = class(TConformance_IEnexAssociativeCollection)
  strict private
    FEmpty, FOne, FFull: IMap<NativeInt, NativeInt>;

  protected
    procedure SetUp_IEnexAssociativeCollection(out AEmpty, AOne, AFull: IEnexAssociativeCollection<NativeInt, NativeInt>; out APairs: TPairs; out AKeyOrdering: TOrdering); override;
    procedure SetUp_IMap(out AEmpty, AOne, AFull: IMap<NativeInt, NativeInt>; out APairs: TPairs; out AKeyOrdering: TOrdering); virtual; abstract;

  published
    procedure Test_Clear;
    procedure Test_Add_1;
    procedure Test_Add_2;
    procedure Test_AddAll;
    procedure Test_Remove;
    procedure Test_ContainsKey;
    procedure Test_ContainsValue;
  end;

  TConformance_IDictionary = class(TConformance_IMap)
  strict private
    FEmpty, FOne, FFull: IMap<NativeInt, NativeInt>;

  protected
    procedure SetUp_IMap(out AEmpty, AOne, AFull: IMap<NativeInt, NativeInt>; out APairs: TPairs; out AKeyOrdering: TOrdering); override;
    procedure SetUp_IDictionary(out AEmpty, AOne, AFull: IDictionary<NativeInt, NativeInt>; out APairs: TPairs; out AKeyOrdering: TOrdering); virtual; abstract;

  published
    procedure Test_Extract;
    procedure Test_TryGetValue;
    procedure Test_GetValue;
    procedure Test_SetValue;
  end;

  TConformance_IBidiDictionary = class(TConformance_IMap)
  strict private
    FEmpty, FOne, FFull: IBidiDictionary<NativeInt, NativeInt>;

  protected
    procedure SetUp_IMap(out AEmpty, AOne, AFull: IMap<NativeInt, NativeInt>; out APairs: TPairs; out AKeyOrdering: TOrdering); override;
    procedure SetUp_IBidiDictionary(out AEmpty, AOne, AFull: IBidiDictionary<NativeInt, NativeInt>; out APairs: TPairs; out AKeyOrdering: TOrdering); virtual; abstract;

  published
    procedure Test_ExtractValueForKey;
    procedure Test_ExtractKeyForValue;
    procedure Test_RemoveValueForKey;
    procedure Test_RemoveKeyForValue;
    procedure Test_RemovePair_1;
    procedure Test_RemovePair_2;
    procedure Test_ContainsPair_1;
    procedure Test_ContainsPair_2;
    procedure Test_TryGetValueForKey;
    procedure Test_GetValueForKey;
    procedure Test_SetValueForKey;
    procedure Test_TryGetKeyForValue;
    procedure Test_GetKeyForValue;
    procedure Test_SetKeyForValue;
  end;

  TConformance_IBidiMap = class(TConformance_IMap)
  strict private
    FEmpty, FOne, FFull: IBidiMap<NativeInt, NativeInt>;

  protected
    procedure SetUp_IMap(out AEmpty, AOne, AFull: IMap<NativeInt, NativeInt>; out APairs: TPairs; out AKeyOrdering: TOrdering); override;
    procedure SetUp_IBidiMap(out AEmpty, AOne, AFull: IBidiMap<NativeInt, NativeInt>; out APairs: TPairs; out AKeyOrdering: TOrdering); virtual; abstract;

  published
    procedure Test_RemoveValuesForKey;
    procedure Test_RemoveKeysForValue;
    procedure Test_RemovePair_1;
    procedure Test_RemovePair_2;
    procedure Test_ContainsPair_1;
    procedure Test_ContainsPair_2;
    procedure Test_GetValuesByKey;
    procedure Test_GetKeysByValue;
  end;

  TConformance_IMultiMap = class(TConformance_IMap)
  strict private
    FEmpty, FOne, FFull: IMultiMap<NativeInt, NativeInt>;

  protected
    procedure SetUp_IMap(out AEmpty, AOne, AFull: IMap<NativeInt, NativeInt>; out APairs: TPairs; out AKeyOrdering: TOrdering); override;
    procedure SetUp_IMultiMap(out AEmpty, AOne, AFull: IMultiMap<NativeInt, NativeInt>; out APairs: TPairs; out AKeyOrdering: TOrdering); virtual; abstract;

  published
    procedure Test_ExtractValues;
    procedure Test_RemovePair_1;
    procedure Test_RemovePair_2;
    procedure Test_ContainsPair_1;
    procedure Test_ContainsPair_2;
    procedure Test_GetValues;
    procedure Test_TryGetValues_1;
    procedure Test_TryGetValues_2;
  end;

  function GenerateUniqueRandomElements: TElements;

implementation

const
  CElements = 100;

function GenerateUniqueRandomElements: TElements;
var
  X, Y, R, L: NativeInt;
  LWas: Boolean;
begin
  Randomize;

  L := 0;
  SetLength(Result, CElements);
  for X := 0 to CElements - 1 do
  begin

    LWas := True;
    while LWas do
    begin
      LWas := False;
      R := Random(MaxInt);

      for Y := 0 to L - 1 do
        if Result[Y] = R then
        begin
          LWas := True;
          Break;
        end;

      if not LWas then
      begin
        Result[L] := R;
        Inc(L);
      end;
    end;
  end;
end;

{ TConformance_IEnumerable_Simple }

procedure TConformance_IEnumerable_Simple.SetUp;
begin
  inherited;

  SetUp_IEnumerable(FEmpty, FOne, FFull, FElements, FOrdering);
end;

procedure TConformance_IEnumerable_Simple.TearDown;
begin
  inherited;

  FEmpty := nil;
  FOne := nil;
  FFull := nil;
end;

procedure TConformance_IEnumerable_Simple.Test_Enumerator_Early_Current;
begin
  {
    Tests:
      1. Current MUST return something even if MoveNext() was not used.
  }
  CheckTrue(FEmpty.GetEnumerator().Current = Default(NativeInt), 'Expected Current to be default for [empty].');
  CheckTrue(FOne.GetEnumerator().Current = Default(NativeInt), 'Expected Current to be default for [one].');
  CheckTrue(FFull.GetEnumerator().Current = Default(NativeInt), 'Expected Current to be default for [full].');
end;

procedure TConformance_IEnumerable_Simple.Test_Enumerator_ReachEnd;
var
  LEnumerator: IEnumerator<NativeInt>;
  LLast, LIndex: NativeInt;
  LList: Generics.Collections.TList<NativeInt>;
  LIsFirst: Boolean;
begin
  {
    Tests:
      1. MoveNext() returns false for Empty.
      2. MoveNext() returns false then true for One.
      3. MoveNext() returns true until end is reached.
      4. Ordering of elements is preserved.
      5. Elements are all enumerated!
      6. After last MoveNext() the next one is also False and Current is not changed.
  }
  LEnumerator := FEmpty.GetEnumerator();
  CheckFalse(LEnumerator.MoveNext(), 'Did not expect a valid 1.MoveNext() for [empty]');
  CheckFalse(LEnumerator.MoveNext(), 'Did not expect a valid 2.MoveNext() for [empty]');

  LEnumerator := FOne.GetEnumerator();
  CheckTrue(LEnumerator.MoveNext(), 'Expected a valid 1.MoveNext() for [one]');
  LLast := LEnumerator.Current;

  CheckFalse(LEnumerator.MoveNext(), 'Did not expect a valid 2.MoveNext() for [one]');
  CheckEquals(LLast, LEnumerator.Current, 'Expected the last value to remain constant for [one]');

  CheckFalse(LEnumerator.MoveNext(), 'Did not expect a valid 3.MoveNext() for [one]');
  CheckEquals(LLast, LEnumerator.Current, 'Expected the last value to remain constant for [one]');
  CheckEquals(LLast, FElements[0], 'Expected the only value to be valid [one]');

  LEnumerator := FFull.GetEnumerator();
  LList := Generics.Collections.TList<NativeInt>.Create();
  LList.AddRange(FElements);
  LIsFirst := False;
  LIndex := 0;

  while LEnumerator.MoveNext() do
  begin
    if LIsFirst then
      LIsFirst := False
    else begin
      { Check ordering if applied }
      if FOrdering = oAscending then
        CheckTrue(LEnumerator.Current >= LLast, 'Expected Vi >= Vi-1 always for [full]!')
      else if FOrdering = oDescending then
        CheckTrue(LEnumerator.Current <= LLast, 'Expected Vi <= Vi-1 always for [full]!');
    end;

    LLast := LEnumerator.Current;

    if FOrdering = oInsert then
      CheckTrue(LList[LIndex] = LLast, 'Expected insert ordering to apply for [full].');

    LList.Remove(LEnumerator.Current);
    Inc(LIndex);
  end;

  { Check that all elements have been enumerated }
  CheckEquals(0, LList.Count, 'Expected that all elements are enumerated in [full].');
  LList.Free;
end;

procedure TConformance_IEnumerable_Simple.Test_GetEnumerator;
var
  LEnumerator: IEnumerator<NativeInt>;
begin
  {
    Tests:
      1. MUST return a valid enumerator.
      2. MUST return always a new enumerator and not re-use another.
  }
  LEnumerator := FEmpty.GetEnumerator();
  CheckTrue(Assigned(LEnumerator), 'Expected a non-nil enumerator for [empty].');
  CheckTrue(Pointer(LEnumerator) <> Pointer(FEmpty.GetEnumerator()), 'Expected a new object enumerator for [empty].');

  LEnumerator := FOne.GetEnumerator();
  CheckTrue(Assigned(LEnumerator), 'Expected a non-nil enumerator for [one].');
  CheckTrue(Pointer(LEnumerator) <> Pointer(FOne.GetEnumerator()), 'Expected a new object enumerator for [one].');

  LEnumerator := FFull.GetEnumerator();
  CheckTrue(Assigned(LEnumerator), 'Expected a non-nil enumerator for [full].');
  CheckTrue(Pointer(LEnumerator) <> Pointer(FFull.GetEnumerator()), 'Expected a new object enumerator for [full].');
end;

{ TConformance_ICollection_Simple }

procedure TConformance_ICollection_Simple.SetUp_IEnumerable(out AEmpty, AOne, AFull: IEnumerable<NativeInt>;
  out AElements: TElements; out AOrdering: TOrdering);
begin
  SetUp_ICollection(FEmpty, FOne, FFull, AElements, AOrdering);

  AEmpty := FEmpty;
  AOne := FOne;
  AFull := FFull;
end;

procedure TConformance_ICollection_Simple.Test_CopyTo_1;
var
  LArray: TArray<NativeInt>;
  LEnumerator: IEnumerator<NativeInt>;
  LIndex: NativeInt;
begin
  {  Tests:
       1. EArgumentOutOfRangeException when index is negative;
       2. EArgumentOutOfSpaceException when index exceeds the free space in the array.
       3. The all elements for [full].
  }
  SetLength(LArray, 1);
  CheckException(EArgumentOutOfRangeException,
    procedure() begin FEmpty.CopyTo(LArray, -1); end,
    'EArgumentOutOfRangeException not thrown in [empty].CopyTo(-1)'
  );
  CheckException(EArgumentOutOfRangeException,
    procedure() begin FEmpty.CopyTo(LArray, 2); end,
    'EArgumentOutOfRangeException not thrown in [empty].CopyTo(2)'
  );
  FEmpty.CopyTo(LArray, 0);
  SetLength(LArray, 0);
  CheckException(EArgumentOutOfRangeException,
    procedure() begin FEmpty.CopyTo(LArray, 0); end,
    'EArgumentOutOfRangeException not thrown in [empty].CopyTo(0)'
  );
  CheckException(EArgumentOutOfRangeException,
    procedure() begin FOne.CopyTo(LArray, 0); end,
    'EArgumentOutOfRangeException not thrown in [one].CopyTo(0)'
  );
  SetLength(LArray, 10);
  CheckException(EArgumentOutOfRangeException,
    procedure() begin FOne.CopyTo(LArray, -1); end,
    'EArgumentOutOfRangeException not thrown in [one].CopyTo(-1)'
  );
  CheckException(EArgumentOutOfRangeException,
    procedure() begin FOne.CopyTo(LArray, 10); end,
    'EArgumentOutOfRangeException not thrown in [one].CopyTo(10)'
  );
  FOne.CopyTo(LArray, 9);
  CheckEquals(LArray[9], Elements[0], 'Expected the element to be coopied properly [one].');


  SetLength(LArray, 0);
  CheckException(EArgumentOutOfRangeException,
    procedure() begin FFull.CopyTo(LArray, 0); end,
    'EArgumentOutOfRangeException not thrown in [full].CopyTo(0)'
  );
  SetLength(LArray, Length(Elements) - 1);
  CheckException(EArgumentOutOfSpaceException,
    procedure() begin FFull.CopyTo(LArray, 0); end,
    'EArgumentOutOfSpaceException not thrown in [full].CopyTo(0)'
  );
  SetLength(LArray, Length(Elements) + 1);
  CheckException(EArgumentOutOfRangeException,
    procedure() begin FFull.CopyTo(LArray, -1); end,
    'EArgumentOutOfRangeException not thrown in [full].CopyTo(-1)'
  );
  CheckException(EArgumentOutOfRangeException,
    procedure() begin FFull.CopyTo(LArray, Length(LArray)); end,
    'EArgumentOutOfRangeException not thrown in [full].CopyTo(L)'
  );
  FFull.CopyTo(LArray, 1);

  LEnumerator := FFull.GetEnumerator();
  LIndex := 1;
  while LEnumerator.MoveNext() do
  begin
    CheckEquals(LEnumerator.Current, LArray[LIndex], 'Expected the copied array to be same order as enumerator for [full].');
    Inc(LIndex);
  end;
  CheckEquals(Length(LArray), LIndex, 'Expected same count as enumerator for [full]');
end;

procedure TConformance_ICollection_Simple.Test_CopyTo_2;
var
  LArray: TArray<NativeInt>;
  LEnumerator: IEnumerator<NativeInt>;
  LIndex: NativeInt;
begin
  {  Tests:
       1. EArgumentOutOfRangeException when index is negative;
       2. EArgumentOutOfSpaceException when index exceeds the free space in the array.
       3. The all elements for [full].
  }
  SetLength(LArray, 1);
  FEmpty.CopyTo(LArray);

  SetLength(LArray, 0);
  CheckException(EArgumentOutOfRangeException,
    procedure() begin FEmpty.CopyTo(LArray); end,
    'EArgumentOutOfRangeException not thrown in [empty].CopyTo()'
  );
  SetLength(LArray, 10);
  FOne.CopyTo(LArray, 9);
  CheckEquals(LArray[9], Elements[0], 'Expected the element to be coopied properly [one].');


  SetLength(LArray, 0);
  CheckException(EArgumentOutOfRangeException,
    procedure() begin FFull.CopyTo(LArray); end,
    'EArgumentOutOfRangeException not thrown in [full].CopyTo()'
  );
  SetLength(LArray, Length(Elements) - 1);
  CheckException(EArgumentOutOfSpaceException,
    procedure() begin FFull.CopyTo(LArray); end,
    'EArgumentOutOfSpaceException not thrown in [full].CopyTo()'
  );
  SetLength(LArray, Length(Elements) + 1);
  FFull.CopyTo(LArray, 1);

  LEnumerator := FFull.GetEnumerator();
  LIndex := 1;
  while LEnumerator.MoveNext() do
  begin
    CheckEquals(LEnumerator.Current, LArray[LIndex], 'Expected the copied array to be same order as enumerator for [full].');
    Inc(LIndex);
  end;
  CheckEquals(Length(LArray), LIndex, 'Expected same count as enumerator for [full]');
end;

procedure TConformance_ICollection_Simple.Test_Empty;
begin
  {  Tests:
       1. Empty is True for [empty].
       2. Empty is False for [one].
       3. Empty is False for [full].
  }

  CheckTrue(FEmpty.Empty, 'Expected empty for [empty].');
  CheckFalse(FOne.Empty, 'Expected non-empty for [one].');
  CheckFalse(FFull.Empty, 'Expected non-empty for [full].');
end;

procedure TConformance_ICollection_Simple.Test_GetCount;
begin
  {  Tests:
       1. Count for [empty] is zero.
       2. Count for [one] is one.
       3. Count for [full] is equal to the length of element array.
  }

  CheckEquals(0, FEmpty.GetCount(), 'Expected zero count for [empty].');
  CheckEquals(1, FOne.GetCount(), 'Expected 1 count for [one].');
  CheckEquals(Length(Elements), FFull.GetCount(), 'Expected > 1 count for [full].');
end;

procedure TConformance_ICollection_Simple.Test_Single;
begin
  {  Tests:
       1. ECollectionEmptyException for [empty].
       2. The value for [one].
       3. ECollectionNotOneException for [full].
  }

  CheckException(ECollectionEmptyException,
    procedure() begin FEmpty.Single(); end,
    'ECollectionEmptyException not thrown in [empty].Single()'
  );

  CheckEquals(Elements[0], FOne.Single(), 'Expected "single" value failed for [one]');

  CheckException(ECollectionNotOneException,
    procedure() begin FFull.Single(); end,
    'ECollectionNotOneException not thrown in [full].Single()'
  );
end;

procedure TConformance_ICollection_Simple.Test_SingleOrDefault;
var
  LSingle: NativeInt;
  LEnumerator: IEnumerator<NativeInt>;
begin
  {  Tests:
       1. ECollectionEmptyException for [empty].
       2. The value for [one].
       3. The default value for [full].
  }

  CheckException(ECollectionEmptyException,
    procedure() begin FEmpty.SingleOrDefault(-1); end,
    'ECollectionEmptyException not thrown in [empty].SingleOrDefault()'
  );

  LSingle := FOne.Single();
  CheckEquals(LSingle, FOne.SingleOrDefault(LSingle - 1), 'Expected "single" value failed for [one]');

  LEnumerator := FFull.GetEnumerator();
  LEnumerator.MoveNext();
  LSingle := LEnumerator.Current;

  CheckEquals(LSingle - 1, FFull.SingleOrDefault(LSingle - 1), 'Expected "default" value failed for [full]');
end;

procedure TConformance_ICollection_Simple.Test_ToArray;
var
  LArray: TArray<NativeInt>;
  LEnumerator: IEnumerator<NativeInt>;
  LIndex: NativeInt;
begin
  {  Tests:
       1. An empty array for [empty].
       2. One-element array for [one].
       3. The all elements for [full].
  }
  LArray := FEmpty.ToArray();
  CheckEquals(0, Length(LArray), 'Expected a length of zero for the elements of [empty].');

  LArray := FOne.ToArray();
  CheckEquals(1, Length(LArray), 'Expected a length of 1 for the elements of [one].');
  CheckEquals(Elements[0], LArray[0], 'Expected a proper single element for [one].');

  LArray := FFull.ToArray();
  CheckEquals(Length(Elements), Length(LArray), 'Expected a proper length for [full].');
  LEnumerator := FFull.GetEnumerator();

  LIndex := 0;
  while LEnumerator.MoveNext() do
  begin
    CheckEquals(LEnumerator.Current, LArray[LIndex], 'Expected the copied array to be same order as enumerator for [full]');
    Inc(LIndex);
  end;
  CheckEquals(Length(LArray), LIndex, 'Expected same count as enumerator for [full]');
end;

procedure TConformance_ICollection_Simple.Test_Version;
begin
  { Tests:
      1. Version() for [empty] is zero.
      2. Version() for [one] is non-zero.
      3. Version() for [full] is bigger than for [one]
  }

  CheckEquals(0, FEmpty.Version(), 'Expected the version for [empty] to be zero.');
  CheckTrue(FOne.Version() > FEmpty.Version(), 'Expected the version for [one] to be bigger than zero.');
  CheckTrue(FFull.Version() > FEmpty.Version(), 'Expected the version for [full] to be bigger than for [one].');
end;

{ TConformance_IEnexCollection }

procedure TConformance_IEnexCollection.SetUp_ICollection(out AEmpty, AOne, AFull: ICollection<NativeInt>;
  out AElements: TElements; out AOrdering: TOrdering);
begin
  SetUp_IEnexCollection(FEmpty, FOne, FFull, AElements, AOrdering);

  AEmpty := FEmpty;
  AOne := FOne;
  AFull := FFull;
end;

procedure TConformance_IEnexCollection.Test_Aggregate;
var
  LAggregator: TFunc<NativeInt, NativeInt, NativeInt>;
  LSum, I: NativeInt;
begin
  { Tests:
      1. EArgumentNilException in all cases for nil predicates.
      2. ECollectionEmptyException for [empty].
      3. Proper aggregation for [one].
      4. Real aggregation for [full].
  }

  CheckException(EArgumentNilException,
    procedure() begin FEmpty.Aggregate(nil) end,
    'EArgumentNilException not thrown in [empty].Aggregate()'
  );
  CheckException(EArgumentNilException,
    procedure() begin FOne.Aggregate(nil) end,
    'EArgumentNilException not thrown in [one].Aggregate()'
  );
  CheckException(EArgumentNilException,
    procedure() begin FFull.Aggregate(nil) end,
    'EArgumentNilException not thrown in [full].Aggregate()'
  );

  LAggregator := function(Arg1, Arg2: NativeInt): NativeInt begin Exit(Arg1 + Arg2); end;

  CheckException(ECollectionEmptyException,
    procedure() begin FEmpty.Aggregate(LAggregator) end,
    'ECollectionEmptyException not thrown in [empty].Aggregate()'
  );

  CheckEquals(Elements[0], FOne.Aggregate(LAggregator), 'Expected the only element for [one]');

  LSum := 0;
  for I := 0 to Length(Elements) - 1 do
    Inc(LSum, Elements[I]);

  CheckEquals(LSum, FFull.Aggregate(LAggregator), 'Expected the sum of elements for [full]');
end;

procedure TConformance_IEnexCollection.Test_AggregateOrDefault;
var
  LAggregator: TFunc<NativeInt, NativeInt, NativeInt>;
  LSum, I: NativeInt;
begin
  { Tests:
      1. EArgumentNilException in all cases for nil predicates.
      2. Proper aggregation for [one].
      3. Real aggregation for [full].
      4. Default for [empty].
  }

  CheckException(EArgumentNilException,
    procedure() begin FEmpty.AggregateOrDefault(nil, -1) end,
    'EArgumentNilException not thrown in [empty].AggregateOrDefault()'
  );
  CheckException(EArgumentNilException,
    procedure() begin FOne.AggregateOrDefault(nil, -1) end,
    'EArgumentNilException not thrown in [one].AggregateOrDefault()'
  );
  CheckException(EArgumentNilException,
    procedure() begin FFull.AggregateOrDefault(nil, -1) end,
    'EArgumentNilException not thrown in [full].AggregateOrDefault()'
  );

  LAggregator := function(Arg1, Arg2: NativeInt): NativeInt begin Exit(Arg1 + Arg2); end;

  CheckEquals(-1, FEmpty.AggregateOrDefault(LAggregator, -1), 'Expected the only element for [empty]');
  CheckEquals(Elements[0], FOne.AggregateOrDefault(LAggregator, Elements[0] - 1), 'Expected the only element for [one]');

  LSum := 0;
  for I := 0 to Length(Elements) - 1 do
    Inc(LSum, Elements[I]);

  CheckEquals(LSum, FFull.AggregateOrDefault(LAggregator, -1), 'Expected the sum of elements for [full]');
end;

procedure TConformance_IEnexCollection.Test_All;
var
  LAlwaysTruePredicate,
    LPredicate: TPredicate<NativeInt>;
  LLast: NativeInt;
begin
  { Tests:
      1. EArgumentNilException for nil predicates.
      2. True for [empty]
      3. True for an always true predicate.
      4. Proper All for [one] and [full].
  }

  CheckException(EArgumentNilException,
    procedure() begin FEmpty.All(nil) end,
    'EArgumentNilException not thrown in [empty].All()'
  );
  CheckException(EArgumentNilException,
    procedure() begin FOne.All(nil) end,
    'EArgumentNilException not thrown in [one].All()'
  );
  CheckException(EArgumentNilException,
    procedure() begin FFull.All(nil) end,
    'EArgumentNilException not thrown in [full].All()'
  );

  LAlwaysTruePredicate := function(Arg: NativeInt): Boolean begin Exit(True); end;
  CheckEquals(True, FEmpty.All(LAlwaysTruePredicate), 'Expected all = true for [empty]');
  CheckEquals(True, FOne.All(LAlwaysTruePredicate), 'Expected all = true for [empty]');
  CheckEquals(True, FFull.All(LAlwaysTruePredicate), 'Expected all = true for [empty]');

  LPredicate := function(Arg: NativeInt): Boolean begin Exit(Arg = Elements[0]); end;
  CheckEquals(True, FOne.All(LPredicate), 'Expected all = true for [one]');

  LLast := FFull.Last;
  LPredicate := function(Arg: NativeInt): Boolean begin Exit(Arg = LLast); end;
  CheckEquals(False, FFull.All(LPredicate), 'Expected all = false for [full]');
end;

procedure TConformance_IEnexCollection.Test_Any;
var
  LAlwaysFalsePredicate,
    LPredicate: TPredicate<NativeInt>;
  LLast: NativeInt;
begin
  { Tests:
      1. EArgumentNilException for nil predicates.
      2. False for [empty]
      3. False for an always false predicate.
      4. Proper All for [one] and [full].
  }

  CheckException(EArgumentNilException,
    procedure() begin FEmpty.Any(nil) end,
    'EArgumentNilException not thrown in [empty].Any()'
  );
  CheckException(EArgumentNilException,
    procedure() begin FOne.Any(nil) end,
    'EArgumentNilException not thrown in [one].Any()'
  );
  CheckException(EArgumentNilException,
    procedure() begin FFull.Any(nil) end,
    'EArgumentNilException not thrown in [full].Any()'
  );

  LAlwaysFalsePredicate := function(Arg: NativeInt): Boolean begin Exit(false); end;
  CheckEquals(False, FEmpty.Any(LAlwaysFalsePredicate), 'Expected any = false for [empty]');
  CheckEquals(False, FOne.Any(LAlwaysFalsePredicate), 'Expected any = false for [empty]');
  CheckEquals(False, FFull.Any(LAlwaysFalsePredicate), 'Expected any = false for [empty]');

  LPredicate := function(Arg: NativeInt): Boolean begin Exit(Arg = Elements[0]); end;
  CheckEquals(True, FOne.Any(LPredicate), 'Expected any = true for [one]');

  LLast := FFull.Last;
  LPredicate := function(Arg: NativeInt): Boolean begin Exit(Arg = LLast); end;
  CheckEquals(True, FFull.Any(LPredicate), 'Expected any = true for [full]');
end;

procedure TConformance_IEnexCollection.Test_Concat;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Distinct;
var
  LSet: ISet<NativeInt>;
  LDistinct: IEnexCollection<NativeInt>;
  LValue: NativeInt;
begin
  { Tests:
      1. Equivalent to ToSet().
      2. [empty] is empty.
      3. [one] has one.
  }

  LDistinct := FEmpty.Distinct();
  CheckTrue(LDistinct.Empty, 'Expected empty distinct result for [empty]');

  LDistinct := FOne.Distinct();
  CheckEquals(1, LDistinct.Count, 'Expected 1-length distinct result for [one]');
  CheckEquals(FOne.Single(), LDistinct.Single(), 'Expected the same element for [one]');

  LDistinct := FFull.Distinct();
  LSet := FFull.ToSet();
  CheckEquals(FFull.Count, LDistinct.Count, 'Expected N-length distinct result for [full]');

  for LValue in LDistinct do
  begin
    CheckTrue(LSet.Contains(LValue), 'Expected the distinct element to be in the set [full].');
    LSet.Remove(LValue);
  end;

  CheckTrue(LSet.Empty, 'Expected same elements in distinct of [full] as in set of [full].');
end;

procedure TConformance_IEnexCollection.Test_ElementAt;
begin
  { Tests:
      1. EArgumentOutOfRangeException for negative, always
      2. EArgumentOutOfRangeException for [empty]
      3. EArgumentOutOfRangeException for actual out of range.
      4. ElementAt[0] = First and ElementAt[L-1] = Last.
  }

  CheckException(EArgumentNilException,
    procedure() begin FEmpty.ElementAt(-1) end,
    'EArgumentNilException not thrown in [empty].ElementAt(-1)'
  );
  CheckException(EArgumentNilException,
    procedure() begin FOne.ElementAt(-1) end,
    'EArgumentNilException not thrown in [one].ElementAt(-1)'
  );
  CheckException(EArgumentNilException,
    procedure() begin FFull.ElementAt(-1) end,
    'EArgumentNilException not thrown in [full].ElementAt(-1)'
  );

  CheckException(ECollectionEmptyException,
    procedure() begin FEmpty.ElementAt(0) end,
    'ECollectionEmptyException not thrown in [empty].ElementAt(0)'
  );
  CheckException(ECollectionEmptyException,
    procedure() begin FOne.ElementAt(1) end,
    'ECollectionEmptyException not thrown in [one].ElementAt(1)'
  );
  CheckException(ECollectionEmptyException,
    procedure() begin FFull.ElementAt(FFull.GetCount()) end,
    'ECollectionEmptyException not thrown in [full].ElementAt(L)'
  );

  CheckEquals(Elements[0], FOne.ElementAt(0), 'Expected element[0] to be correct in [one]');
  CheckEquals(FFull.First, FFull.ElementAt(0), 'Expected element[0] to be equal to First in [full]');
  CheckEquals(FFull.Last, FFull.ElementAt(FFull.GetCount() - 1), 'Expected element[L-1] to be equal to Last in [full]');
end;

procedure TConformance_IEnexCollection.Test_ElementAtOrDefault;
begin
  { Tests:
      1. EArgumentOutOfRangeException for negative, always
      2. The default for [empty], or out-of-range.
      4. ElementAtOrDefault[0] = First and ElementAtOrDefault[L-1] = Last.
  }

  CheckException(EArgumentNilException,
    procedure() begin FEmpty.ElementAtOrDefault(-1, -1) end,
    'EArgumentNilException not thrown in [empty].ElementAtOrDefault(-1)'
  );
  CheckException(EArgumentNilException,
    procedure() begin FOne.ElementAtOrDefault(-1, -1) end,
    'EArgumentNilException not thrown in [one].ElementAtOrDefault(-1)'
  );
  CheckException(EArgumentNilException,
    procedure() begin FFull.ElementAtOrDefault(-1, -1) end,
    'EArgumentNilException not thrown in [full].ElementAtOrDefault(-1)'
  );

  CheckEquals(-1, FEmpty.ElementAtOrDefault(0, -1), 'Expected default in [empty]');
  CheckEquals(-1, FOne.ElementAtOrDefault(1, -1), 'Expected default in [one]');
  CheckEquals(-1, FFull.ElementAtOrDefault(1, FFull.Count - 1), 'Expected default in [full]');

  CheckEquals(Elements[0], FOne.ElementAtOrDefault(0, Elements[0] - 1), 'Expected element[0] to be correct in [one]');
  CheckEquals(FFull.First, FFull.ElementAtOrDefault(0, FFull.First - 1), 'Expected element[0] to be equal to First in [full]');
  CheckEquals(FFull.Last, FFull.ElementAtOrDefault(FFull.GetCount() - 1, FFull.Last - 1), 'Expected element[L-1] to be equal to Last in [full]');
end;

procedure TConformance_IEnexCollection.Test_EqualsTo;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Exclude;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_First;
var
  LEnumerator: IEnumerator<NativeInt>;
begin
  { Tests:
      1. ECollectionEmptyException for [empty].
      2. The actual element for [one].
      3. The actual first element for [full].
  }

  CheckException(ECollectionEmptyException,
    procedure() begin FEmpty.First() end,
    'ECollectionEmptyException not thrown in [empty].First()'
  );

  CheckEquals(Elements[0], FOne.First(), 'Expected proper first for [one].');

  LEnumerator := FFull.GetEnumerator();
  LEnumerator.MoveNext();
  CheckEquals(LEnumerator.Current, FFull.First(), 'Expected proper first for [full].');
end;

procedure TConformance_IEnexCollection.Test_FirstOrDefault;
var
  LEnumerator: IEnumerator<NativeInt>;
begin
  { Tests:
      1. The default for [empty]
      2. The actual element for [one].
      3. The actual first element for [full].
  }

  CheckEquals(-1, FEmpty.FirstOrDefault(-1), 'Expected proper first for [empty].');
  CheckEquals(Elements[0], FOne.FirstOrDefault(Elements[0] - 1), 'Expected proper first for [one].');

  LEnumerator := FFull.GetEnumerator();
  LEnumerator.MoveNext();
  CheckEquals(LEnumerator.Current, FFull.FirstOrDefault(LEnumerator.Current - 1), 'Expected proper first for [full].');
end;

procedure TConformance_IEnexCollection.Test_FirstWhere;
var
  LAlwaysFalsePredicate,
    LPredicate: TPredicate<NativeInt>;
begin
  { Tests:
      1. ECollectionFilteredEmptyException for [empty].
      2. ECollectionFilteredEmptyException for [one] but wrong predicate.
      3. ECollectionFilteredEmptyException for [full] but wrong predicate.
      4. The actual element for [one] with a proper predicate.
      5. The actual elemnts for [full] with a proper predicate.
      6. EArgumentNilException if the predicate is nil.
  }

  CheckException(EArgumentNilException,
    procedure() begin FEmpty.FirstWhere(nil) end,
    'EArgumentNilException not thrown in [empty].FirstWhere()'
  );
  CheckException(EArgumentNilException,
    procedure() begin FOne.FirstWhere(nil) end,
    'EArgumentNilException not thrown in [one].FirstWhere()'
  );
  CheckException(EArgumentNilException,
    procedure() begin FFull.FirstWhere(nil) end,
    'EArgumentNilException not thrown in [full].FirstWhere()'
  );

  LAlwaysFalsePredicate := function(Arg: NativeInt): Boolean begin Exit(false); end;

  CheckException(ECollectionFilteredEmptyException,
    procedure() begin FFull.FirstWhere(LAlwaysFalsePredicate) end,
    'ECollectionFilteredEmptyException not thrown in [empty].FirstWhere(false)'
  );
  CheckException(ECollectionFilteredEmptyException,
    procedure() begin FFull.FirstWhere(LAlwaysFalsePredicate) end,
    'ECollectionFilteredEmptyException not thrown in [one].FirstWhere(false)'
  );
  CheckException(ECollectionFilteredEmptyException,
    procedure() begin FFull.FirstWhere(LAlwaysFalsePredicate) end,
    'ECollectionFilteredEmptyException not thrown in [full].FirstWhere(false)'
  );

  LPredicate := function(Arg: NativeInt): Boolean begin Exit(Arg = Elements[0]); end;
  CheckEquals(Elements[0], FOne.FirstWhere(LPredicate), 'Expected first element for [one]');
  CheckEquals(Elements[0], FFull.FirstWhere(LPredicate), 'Expected proper element for [full]');
end;

procedure TConformance_IEnexCollection.Test_FirstWhereNot;
var
  LAlwaysTruePredicate,
    LPredicate: TPredicate<NativeInt>;
begin
  { Tests:
      1. ECollectionFilteredEmptyException for [empty].
      2. ECollectionFilteredEmptyException for [one] but wrong predicate.
      3. ECollectionFilteredEmptyException for [full] but wrong predicate.
      4. The actual element for [one] with a proper predicate.
      5. The actual elemnts for [full] with a proper predicate.
      6. EArgumentNilException if the predicate is nil.
  }

  CheckException(EArgumentNilException,
    procedure() begin FEmpty.FirstWhereNot(nil) end,
    'EArgumentNilException not thrown in [empty].FirstWhereNot()'
  );
  CheckException(EArgumentNilException,
    procedure() begin FOne.FirstWhereNot(nil) end,
    'EArgumentNilException not thrown in [one].FirstWhereNot()'
  );
  CheckException(EArgumentNilException,
    procedure() begin FFull.FirstWhereNot(nil) end,
    'EArgumentNilException not thrown in [full].FirstWhereNot()'
  );

  LAlwaysTruePredicate := function(Arg: NativeInt): Boolean begin Exit(true); end;

  CheckException(ECollectionFilteredEmptyException,
    procedure() begin FFull.FirstWhereNot(LAlwaysTruePredicate) end,
    'ECollectionFilteredEmptyException not thrown in [empty].FirstWhereNot(false)'
  );
  CheckException(ECollectionFilteredEmptyException,
    procedure() begin FFull.FirstWhereNot(LAlwaysTruePredicate) end,
    'ECollectionFilteredEmptyException not thrown in [one].FirstWhereNot(false)'
  );
  CheckException(ECollectionFilteredEmptyException,
    procedure() begin FFull.FirstWhereNot(LAlwaysTruePredicate) end,
    'ECollectionFilteredEmptyException not thrown in [full].FirstWhereNot(false)'
  );

  LPredicate := function(Arg: NativeInt): Boolean begin Exit(Arg <> Elements[0]); end;
  CheckEquals(Elements[0], FOne.FirstWhereNot(LPredicate), 'Expected first element for [one]');
  CheckEquals(Elements[0], FFull.FirstWhereNot(LPredicate), 'Expected proper element for [full]');
end;

procedure TConformance_IEnexCollection.Test_FirstWhereNotOrDefault;
var
  LAlwaysTruePredicate,
    LPredicate: TPredicate<NativeInt>;
begin
  { Tests:
      1. ECollectionFilteredEmptyException for [empty].
      2. ECollectionFilteredEmptyException for [one] but wrong predicate.
      3. ECollectionFilteredEmptyException for [full] but wrong predicate.
      4. The actual element for [one] with a proper predicate.
      5. The actual elemnts for [full] with a proper predicate.
      6. EArgumentNilException if the predicate is nil.
  }

  CheckException(EArgumentNilException,
    procedure() begin FEmpty.FirstWhereNotOrDefault(nil, -1) end,
    'EArgumentNilException not thrown in [empty].FirstWhereOrDefault()'
  );
  CheckException(EArgumentNilException,
    procedure() begin FOne.FirstWhereNotOrDefault(nil, -1) end,
    'EArgumentNilException not thrown in [one].FirstWhereOrDefault()'
  );
  CheckException(EArgumentNilException,
    procedure() begin FFull.FirstWhereNotOrDefault(nil, -1) end,
    'EArgumentNilException not thrown in [full].FirstWhereOrDefault()'
  );

  LAlwaysTruePredicate := function(Arg: NativeInt): Boolean begin Exit(True); end;
  CheckEquals(-1, FEmpty.FirstWhereNotOrDefault(LAlwaysTruePredicate, -1), 'Expected -1 element for [empty]');
  CheckEquals(-1, FOne.FirstWhereNotOrDefault(LAlwaysTruePredicate, -1), 'Expected -1 element for [one]');
  CheckEquals(-1, FFull.FirstWhereNotOrDefault(LAlwaysTruePredicate, -1), 'Expected -1 element for [full]');

  LPredicate := function(Arg: NativeInt): Boolean begin Exit(Arg <> Elements[0]); end;
  CheckEquals(Elements[0], FOne.FirstWhereNotOrDefault(LPredicate, Elements[0] - 1), 'Expected first element for [one]');
  CheckEquals(Elements[0], FFull.FirstWhereNotOrDefault(LPredicate, Elements[0] - 1), 'Expected proper element for [full]');
end;

procedure TConformance_IEnexCollection.Test_FirstWhereOrDefault;
var
  LAlwaysFalsePredicate,
    LPredicate: TPredicate<NativeInt>;
begin
  { Tests:
      1. ECollectionFilteredEmptyException for [empty].
      2. ECollectionFilteredEmptyException for [one] but wrong predicate.
      3. ECollectionFilteredEmptyException for [full] but wrong predicate.
      4. The actual element for [one] with a proper predicate.
      5. The actual elemnts for [full] with a proper predicate.
      6. EArgumentNilException if the predicate is nil.
  }

  CheckException(EArgumentNilException,
    procedure() begin FEmpty.FirstWhereOrDefault(nil, -1) end,
    'EArgumentNilException not thrown in [empty].FirstWhereOrDefault()'
  );
  CheckException(EArgumentNilException,
    procedure() begin FOne.FirstWhereOrDefault(nil, -1) end,
    'EArgumentNilException not thrown in [one].FirstWhereOrDefault()'
  );
  CheckException(EArgumentNilException,
    procedure() begin FFull.FirstWhereOrDefault(nil, -1) end,
    'EArgumentNilException not thrown in [full].FirstWhereOrDefault()'
  );

  LAlwaysFalsePredicate := function(Arg: NativeInt): Boolean begin Exit(false); end;
  CheckEquals(-1, FEmpty.FirstWhereOrDefault(LAlwaysFalsePredicate, -1), 'Expected -1 element for [empty]');
  CheckEquals(-1, FOne.FirstWhereOrDefault(LAlwaysFalsePredicate, -1), 'Expected -1 element for [one]');
  CheckEquals(-1, FFull.FirstWhereOrDefault(LAlwaysFalsePredicate, -1), 'Expected -1 element for [full]');

  LPredicate := function(Arg: NativeInt): Boolean begin Exit(Arg = Elements[0]); end;
  CheckEquals(Elements[0], FOne.FirstWhereOrDefault(LPredicate, Elements[0] - 1), 'Expected first element for [one]');
  CheckEquals(Elements[0], FFull.FirstWhereOrDefault(LPredicate, Elements[0] - 1), 'Expected proper element for [full]');
end;

procedure TConformance_IEnexCollection.Test_Intersect;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Last;
var
  LEnumerator: IEnumerator<NativeInt>;
begin
  { Tests:
      1. ECollectionEmptyException for [empty].
      2. The actual element for [one].
      3. The actual first element for [full].
  }

  CheckException(ECollectionEmptyException,
    procedure() begin FEmpty.Last() end,
    'ECollectionEmptyException not thrown in [empty].Last()'
  );

  CheckEquals(Elements[0], FOne.Last(), 'Expected proper last for [one].');

  LEnumerator := FFull.GetEnumerator();
  while LEnumerator.MoveNext() do;
  CheckEquals(LEnumerator.Current, FFull.Last(), 'Expected proper last for [full].');
end;

procedure TConformance_IEnexCollection.Test_LastOrDefault;
var
  LEnumerator: IEnumerator<NativeInt>;
begin
  { Tests:
      1. The default for [empty]
      2. The actual element for [one].
      3. The actual first element for [full].
  }

  CheckEquals(-1, FEmpty.LastOrDefault(-1), 'Expected proper last for [empty].');
  CheckEquals(Elements[0], FOne.LastOrDefault(Elements[0] - 1), 'Expected proper last for [one].');

  LEnumerator := FFull.GetEnumerator();
  while LEnumerator.MoveNext() do;
  CheckEquals(LEnumerator.Current, FFull.LastOrDefault(LEnumerator.Current - 1), 'Expected proper last for [full].');
end;

procedure TConformance_IEnexCollection.Test_Max;
var
  LMax, LIndex: NativeInt;
begin
  { Tests:
      1. ECollectionEmptyException for [empty].
      2. The actual element for [one].
      3. The actual max for [full].
      4. Max = Last for ascending and First for descending.
  }

  CheckException(ECollectionEmptyException,
    procedure() begin FEmpty.Max() end,
    'ECollectionEmptyException not thrown in [empty].Max()'
  );

  CheckEquals(Elements[0], FOne.Max(), 'Expected proper max for [one]');

  LMax := Elements[0];
  for LIndex := 1 to Length(Elements) - 1 do
    if LMax < Elements[LIndex] then
      LMax := Elements[LIndex];

  CheckEquals(LMax, FFull.Max(), 'Expected proper max for [full]');

  if Ordering = oAscending then
  begin
    CheckEquals(FFull.Max(), FFull.Last(), 'Expected Max to be equal to Last in [full]');
    CheckEquals(FFull.Max(), FFull.ElementAt(FFull.Count - 1), 'Expected Max to be equal to [L-1] in [full]');
  end;
  if Ordering = oDescending then
  begin
    CheckEquals(FFull.Max(), FFull.First(), 'Expected Max to be equal to First in [full]');
    CheckEquals(FFull.Max(), FFull.ElementAt(0), 'Expected Max to be equal to [0] in [full]');
  end;
end;

procedure TConformance_IEnexCollection.Test_Min;
var
  LMin, LIndex: NativeInt;
begin
  { Tests:
      1. ECollectionEmptyException for [empty].
      2. The actual element for [one].
      3. The actual min for [full].
      4. Min = First for ascending and Last for descending.
  }

  CheckException(ECollectionEmptyException,
    procedure() begin FEmpty.Min() end,
    'ECollectionEmptyException not thrown in [empty].Min()'
  );

  CheckEquals(Elements[0], FOne.Min(), 'Expected proper min for [one]');

  LMin := Elements[0];
  for LIndex := 1 to Length(Elements) - 1 do
    if LMin > Elements[LIndex] then
      LMin := Elements[LIndex];

  CheckEquals(LMin, FFull.Min(), 'Expected proper min for [full]');

  if Ordering = oAscending then
  begin
    CheckEquals(FFull.Min(), FFull.First(), 'Expected Min to be equal to First in [full]');
    CheckEquals(FFull.Max(), FFull.ElementAt(0), 'Expected Max to be equal to [0] in [full]');
  end;
  if Ordering = oDescending then
  begin
    CheckEquals(FFull.Min(), FFull.Last(), 'Expected Min to be equal to Last in [full]');
    CheckEquals(FFull.Max(), FFull.ElementAt(FFull.Count - 1), 'Expected Max to be equal to [L-1] in [full]');
  end;
end;

procedure TConformance_IEnexCollection.Test_Op_GroupBy;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Op_Select_1;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Op_Select_2;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Op_Select_3;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Op_Select_4;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Op_Select_5;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Ordered_1;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Ordered_2;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Range;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Reversed;
var
  LReversed: IEnexCollection<NativeInt>;
  LArray: TArray<NativeInt>;
  LIndex, LValue: NativeInt;
begin
  { Test:
      1. [empty] is empty.
      2. [one] is one.
      3. [full] is reversed.
      4. order is preserved in reversed.
  }

  LReversed := FEmpty.Reversed();
  CheckTrue(LReversed.Empty, 'Expected reversed of [empty] to be empty');

  LReversed := FOne.Reversed();
  CheckEquals(1, LReversed.Count, 'Expected reversed of [one] to be 1-length.');
  CheckEquals(FOne.Single, LReversed.Single, 'Expected reversed of [one] to have the same element.');

  LReversed := FFull.Reversed();
  CheckEquals(FFull.Count, LReversed.Count, 'Expected reversed of [full] to be the same length.');
  LArray := LReversed.ToArray();

  LIndex := Length(LArray) - 1;
  for LValue in FFull do
  begin
    CheckEquals(LValue, LArray[LIndex], 'Expected proper reversing in [full].');
    Dec(LIndex);
  end;
end;

procedure TConformance_IEnexCollection.Test_Skip;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_SkipWhile;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Take;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_TakeWhile;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_ToList;
var
  LList: IList<NativeInt>;
  LIndex: NativeInt;
begin
  {  Tests:
       1. Empty list for [empty].
       2. List with one element for [one].
       3. List with all elements for [full].
       4. New list each time.
  }

  LList := FEmpty.ToList();
  CheckTrue(Pointer(LList) <> Pointer(FEmpty.ToList()), 'Expected new list for [empty]');
  CheckTrue(LList.Empty, 'Expected empty list for [empty]');

  LList := FOne.ToList();
  CheckTrue(Pointer(LList) <> Pointer(FOne.ToList()), 'Expected new list for [one]');
  CheckEquals(1, LList.GetCount(), 'Expected one-element list for [one]');
  CheckEquals(Elements[0], LList.GetItem(0), 'Expected proper element copy for [one]');

  LList := FFull.ToList();
  CheckTrue(Pointer(LList) <> Pointer(FFull.ToList()), 'Expected new list for [full]');
  CheckEquals(Length(Elements), LList.GetCount(), 'Expected full-element list for [full]');

  for LIndex := 0 to LList.Count - 1 do
    CheckEquals(Elements[LIndex], LList.GetItem(LIndex), 'Expected proper element copy for [full]');
end;

procedure TConformance_IEnexCollection.Test_ToSet;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Union;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Where;
var
  LAlwaysFalsePredicate,
    LPredicate: TPredicate<NativeInt>;
  LCollection: IEnexCollection<NativeInt>;
  LF, LL: NativeInt;
begin
  { Tests:
      1. EArgumentNilException for nil predicates.
      2. Empty collection for always false predicate.
  }

  CheckException(EArgumentNilException,
    procedure() begin FEmpty.Where(nil) end,
    'EArgumentNilException not thrown in [empty].Where()'
  );
  CheckException(EArgumentNilException,
    procedure() begin FOne.Where(nil) end,
    'EArgumentNilException not thrown in [one].Where()'
  );
  CheckException(EArgumentNilException,
    procedure() begin FFull.Where(nil) end,
    'EArgumentNilException not thrown in [full].Where()'
  );

  LAlwaysFalsePredicate := function(Arg: NativeInt): Boolean begin Exit(False); end;

  LCollection := FEmpty.Where(LAlwaysFalsePredicate);
  CheckEquals(True, LCollection.Empty, 'Expected empty where collection for [empty]');

  LCollection := FOne.Where(LAlwaysFalsePredicate);
  CheckEquals(True, LCollection.Empty, 'Expected empty where collection for [one]');

  LCollection := FFull.Where(LAlwaysFalsePredicate);
  CheckEquals(True, LCollection.Empty, 'Expected empty where collection for [full]');

  LF := FOne.First; LL := FOne.Last;
  LPredicate := function(Arg: NativeInt): Boolean begin Exit((Arg = LF) or (Arg = LL)); end;
  LCollection := FOne.Where(LPredicate);
  CheckEquals(1, LCollection.Count, 'Expected 1-length where collection for [one]');
  CheckEquals(LF, LCollection.First, 'Expected proper selected element for [one]');

  LF := FFull.First; LL := FFull.Last;
  LPredicate := function(Arg: NativeInt): Boolean begin Exit((Arg = LF) or (Arg = LL)); end;
  LCollection := FFull.Where(LPredicate);
  CheckEquals(2, LCollection.Count, 'Expected 2-length where collection for [one]');
  CheckEquals(LF, LCollection.First, 'Expected proper 1 selected element for [one]');
  CheckEquals(LL, LCollection.Last, 'Expected proper 2 selected element for [one]');
end;

procedure TConformance_IEnexCollection.Test_WhereNot;
var
  LAlwaysTruePredicate,
    LPredicate: TPredicate<NativeInt>;
  LCollection: IEnexCollection<NativeInt>;
  LF, LL: NativeInt;
begin
  { Tests:
      1. EArgumentNilException for nil predicates.
      2. Empty collection for always false predicate.
  }

  CheckException(EArgumentNilException,
    procedure() begin FEmpty.WhereNot(nil) end,
    'EArgumentNilException not thrown in [empty].WhereNot()'
  );
  CheckException(EArgumentNilException,
    procedure() begin FOne.WhereNot(nil) end,
    'EArgumentNilException not thrown in [one].WhereNot()'
  );
  CheckException(EArgumentNilException,
    procedure() begin FFull.WhereNot(nil) end,
    'EArgumentNilException not thrown in [full].WhereNot()'
  );

  LAlwaysTruePredicate := function(Arg: NativeInt): Boolean begin Exit(True); end;

  LCollection := FEmpty.WhereNot(LAlwaysTruePredicate);
  CheckEquals(True, LCollection.Empty, 'Expected empty where collection for [empty]');

  LCollection := FOne.WhereNot(LAlwaysTruePredicate);
  CheckEquals(True, LCollection.Empty, 'Expected empty where collection for [one]');

  LCollection := FFull.WhereNot(LAlwaysTruePredicate);
  CheckEquals(True, LCollection.Empty, 'Expected empty where collection for [full]');

  LF := FOne.First; LL := FOne.Last;
  LPredicate := function(Arg: NativeInt): Boolean begin Exit((Arg <> LF) and (Arg <> LL)); end;
  LCollection := FOne.WhereNot(LPredicate);
  CheckEquals(1, LCollection.Count, 'Expected 1-length where collection for [one]');
  CheckEquals(LF, LCollection.First, 'Expected proper selected element for [one]');

  LF := FFull.First; LL := FFull.Last;
  LPredicate := function(Arg: NativeInt): Boolean begin Exit((Arg <> LF) and (Arg <> LL)); end;
  LCollection := FFull.WhereNot(LPredicate);
  CheckEquals(2, LCollection.Count, 'Expected 2-length where collection for [one]');
  CheckEquals(LF, LCollection.First, 'Expected proper 1 selected element for [one]');
  CheckEquals(LL, LCollection.Last, 'Expected proper 2 selected element for [one]');
end;

{ TConformance_IGrouping }

procedure TConformance_IGrouping.SetUp_IEnexCollection(out AEmpty, AOne, AFull: IEnexCollection<NativeInt>;
  out AElements: TElements; out AOrdering: TOrdering);
begin
  SetUp_IGrouping(FEmpty, FOne, FFull, FKey, AElements, AOrdering);

  AEmpty := FEmpty;
  AOne := FOne;
  AFull := FFull;
end;

procedure TConformance_IGrouping.Test_GetKey;
begin
  Fail('Not implemented!');
end;

{ TConformance_IOperableCollection }

procedure TConformance_IOperableCollection.SetUp_IEnexCollection(out AEmpty, AOne, AFull: IEnexCollection<NativeInt>;
  out AElements: TElements; out AOrdering: TOrdering);
begin
  SetUp_IOperableCollection(FEmpty, FOne, FFull, AElements, AOrdering);

  AEmpty := FEmpty;
  AOne := FOne;
  AFull := FFull;
end;

procedure TConformance_IOperableCollection.Test_Add;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IOperableCollection.Test_AddAll;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IOperableCollection.Test_Clear;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IOperableCollection.Test_Contains;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IOperableCollection.Test_ContainsAll;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IOperableCollection.Test_Remove;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IOperableCollection.Test_RemoveAll;
begin
  Fail('Not implemented!');
end;

{ TConformance_IStack }

procedure TConformance_IStack.SetUp_IOperableCollection(out AEmpty, AOne, AFull: IOperableCollection<NativeInt>;
  out AElements: TElements; out AOrdering: TOrdering);
begin
  SetUp_IStack(FEmpty, FOne, FFull, AElements, AOrdering);

  AEmpty := FEmpty;
  AOne := FOne;
  AFull := FFull;
end;

procedure TConformance_IStack.Test_Peek;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IStack.Test_Pop;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IStack.Test_Push;
begin
  Fail('Not implemented!');
end;

{ TConformance_IQueue }

procedure TConformance_IQueue.SetUp_IOperableCollection(out AEmpty, AOne, AFull: IOperableCollection<NativeInt>;
  out AElements: TElements; out AOrdering: TOrdering);
begin
  SetUp_IQueue(FEmpty, FOne, FFull, AElements, AOrdering);

  AEmpty := FEmpty;
  AOne := FOne;
  AFull := FFull;
end;

procedure TConformance_IQueue.Test_Dequeue;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IQueue.Test_Enqueue;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IQueue.Test_Peek;
begin
  Fail('Not implemented!');
end;

{ TConformance_ISortedSet }

procedure TConformance_ISortedSet.SetUp_ISet(out AEmpty, AOne, AFull: ISet<NativeInt>;
  out AElements: TElements; out AOrdering: TOrdering);
begin
  SetUp_ISortedSet(FEmpty, FOne, FFull, AElements, AOrdering);

  AEmpty := FEmpty;
  AOne := FOne;
  AFull := FFull;
end;

procedure TConformance_ISortedSet.Test_Max;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ISortedSet.Test_Min;
begin
  Fail('Not implemented!');
end;

{ TConformance_IList }

procedure TConformance_IList.SetUp_IOperableCollection(out AEmpty, AOne, AFull: IOperableCollection<NativeInt>;
  out AElements: TElements; out AOrdering: TOrdering);
begin
  SetUp_IList(FEmpty, FOne, FFull, AElements, AOrdering);

  AEmpty := FEmpty;
  AOne := FOne;
  AFull := FFull;
end;

procedure TConformance_IList.Test_ExtractAt;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IList.Test_GetItem;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IList.Test_IndexOf_1;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IList.Test_IndexOf_2;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IList.Test_IndexOf_3;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IList.Test_Insert;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IList.Test_Insert_All;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IList.Test_LastIndexOf_1;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IList.Test_LastIndexOf_2;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IList.Test_LastIndexOf_3;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IList.Test_RemoveAt;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IList.Test_SetItem;
begin
  Fail('Not implemented!');
end;

{ TConformance_ILinkedList }

procedure TConformance_ILinkedList.SetUp_IList(out AEmpty, AOne, AFull: IList<NativeInt>;
  out AElements: TElements; out AOrdering: TOrdering);
begin
  SetUp_ILinkedList(FEmpty, FOne, FFull, AElements, AOrdering);

  AEmpty := FEmpty;
  AOne := FOne;
  AFull := FFull;
end;

procedure TConformance_ILinkedList.Test_AddAllFirst;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ILinkedList.Test_AddAllLast;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ILinkedList.Test_AddFirst;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ILinkedList.Test_AddLast;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ILinkedList.Test_ExtractFirst;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ILinkedList.Test_ExtractLast;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ILinkedList.Test_First;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ILinkedList.Test_Last;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ILinkedList.Test_RemoveFirst;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ILinkedList.Test_RemoveLast;
begin
  Fail('Not implemented!');
end;


{ TConformance_IEnumerable_Associative }

procedure TConformance_IEnumerable_Associative.SetUp;
begin
  inherited;

  SetUp_IEnumerable(FEmpty, FOne, FFull, FPairs, FKeyOrdering);
end;

procedure TConformance_IEnumerable_Associative.TearDown;
begin
  inherited;

  FEmpty := nil;
  FOne := nil;
  FFull := nil;
end;

procedure TConformance_IEnumerable_Associative.Test_Enumerator_Early_Current;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnumerable_Associative.Test_Enumerator_ReachEnd;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnumerable_Associative.Test_GetEnumerator;
begin
  Fail('Not implemented!');
end;

{ TConformance_ICollection_Associative }

procedure TConformance_ICollection_Associative.SetUp_IEnumerable(out AEmpty, AOne, AFull: IEnumerable<TPair<NativeInt, NativeInt>>;
  out APairs: TPairs; out AKeyOrdering: TOrdering);
begin
  SetUp_ICollection(FEmpty, FOne, FFull, APairs, AKeyOrdering);

  AEmpty := FEmpty;
  AOne := FOne;
  AFull := FFull;
end;

procedure TConformance_ICollection_Associative.Test_CopyTo_1;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ICollection_Associative.Test_CopyTo_2;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ICollection_Associative.Test_Empty;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ICollection_Associative.Test_GetCount;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ICollection_Associative.Test_Single;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ICollection_Associative.Test_SingleOrDefault;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ICollection_Associative.Test_ToArray;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ICollection_Associative.Test_Version;
begin
  Fail('Not implemented!');
end;

{ TConformance_IEnexAssociativeCollection }

procedure TConformance_IEnexAssociativeCollection.SetUp_ICollection(out AEmpty, AOne, AFull: ICollection<TPair<NativeInt, NativeInt>>;
  out APairs: TPairs; out AKeyOrdering: TOrdering);
begin
  SetUp_IEnexAssociativeCollection(FEmpty, FOne, FFull, APairs, AKeyOrdering);

  AEmpty := FEmpty;
  AOne := FOne;
  AFull := FFull;
end;

procedure TConformance_IEnexAssociativeCollection.Test_DistinctByKeys;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_DistinctByValues;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_Includes;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_KeyHasValue;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_MaxKey;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_MaxValue;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_MinKey;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_MinValue;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_SelectKeys;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_SelectValues;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_ToDictionary;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_ValueForKey;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_Where;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_WhereNot;
begin
  Fail('Not implemented!');
end;

{ TConformance_IMap }

procedure TConformance_IMap.SetUp_IEnexAssociativeCollection(out AEmpty, AOne, AFull: IEnexAssociativeCollection<NativeInt, NativeInt>;
  out APairs: TPairs; out AKeyOrdering: TOrdering);
begin
  SetUp_IMap(FEmpty, FOne, FFull, APairs, AKeyOrdering);

  AEmpty := FEmpty;
  AOne := FOne;
  AFull := FFull;
end;

procedure TConformance_IMap.Test_AddAll;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IMap.Test_Add_1;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IMap.Test_Add_2;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IMap.Test_Clear;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IMap.Test_ContainsKey;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IMap.Test_ContainsValue;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IMap.Test_Remove;
begin
  Fail('Not implemented!');
end;

{ TConformance_IDictionary }

procedure TConformance_IDictionary.SetUp_IMap(out AEmpty, AOne, AFull: IMap<NativeInt, NativeInt>;
  out APairs: TPairs; out AKeyOrdering: TOrdering);
begin
  SetUp_IMap(FEmpty, FOne, FFull, APairs, AKeyOrdering);

  AEmpty := FEmpty;
  AOne := FOne;
  AFull := FFull;
end;

procedure TConformance_IDictionary.Test_Extract;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IDictionary.Test_GetValue;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IDictionary.Test_SetValue;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IDictionary.Test_TryGetValue;
begin
  Fail('Not implemented!');
end;

{ TConformance_IBidiDictionary }

procedure TConformance_IBidiDictionary.SetUp_IMap(out AEmpty, AOne, AFull: IMap<NativeInt, NativeInt>;
  out APairs: TPairs; out AKeyOrdering: TOrdering);
begin
  SetUp_IBidiDictionary(FEmpty, FOne, FFull, APairs, AKeyOrdering);

  AEmpty := FEmpty;
  AOne := FOne;
  AFull := FFull;
end;

procedure TConformance_IBidiDictionary.Test_ContainsPair_1;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBidiDictionary.Test_ContainsPair_2;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBidiDictionary.Test_ExtractKeyForValue;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBidiDictionary.Test_ExtractValueForKey;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBidiDictionary.Test_GetKeyForValue;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBidiDictionary.Test_GetValueForKey;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBidiDictionary.Test_RemoveKeyForValue;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBidiDictionary.Test_RemovePair_1;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBidiDictionary.Test_RemovePair_2;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBidiDictionary.Test_RemoveValueForKey;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBidiDictionary.Test_SetKeyForValue;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBidiDictionary.Test_SetValueForKey;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBidiDictionary.Test_TryGetKeyForValue;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBidiDictionary.Test_TryGetValueForKey;
begin
  Fail('Not implemented!');
end;

{ TConformance_IBidiMap }

procedure TConformance_IBidiMap.SetUp_IMap(out AEmpty, AOne, AFull: IMap<NativeInt, NativeInt>;
  out APairs: TPairs; out AKeyOrdering: TOrdering);
begin
  SetUp_IBidiMap(FEmpty, FOne, FFull, APairs, AKeyOrdering);

  AEmpty := FEmpty;
  AOne := FOne;
  AFull := FFull;
end;

procedure TConformance_IBidiMap.Test_ContainsPair_1;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBidiMap.Test_ContainsPair_2;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBidiMap.Test_GetKeysByValue;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBidiMap.Test_GetValuesByKey;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBidiMap.Test_RemoveKeysForValue;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBidiMap.Test_RemovePair_1;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBidiMap.Test_RemovePair_2;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBidiMap.Test_RemoveValuesForKey;
begin
  Fail('Not implemented!');
end;

{ TConformance_IMultiMap }

procedure TConformance_IMultiMap.SetUp_IMap(out AEmpty, AOne, AFull: IMap<NativeInt, NativeInt>;
  out APairs: TPairs; out AKeyOrdering: TOrdering);
begin
  SetUp_IMultiMap(FEmpty, FOne, FFull, APairs, AKeyOrdering);

  AEmpty := FEmpty;
  AOne := FOne;
  AFull := FFull;
end;

procedure TConformance_IMultiMap.Test_ContainsPair_1;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IMultiMap.Test_ContainsPair_2;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IMultiMap.Test_ExtractValues;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IMultiMap.Test_GetValues;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IMultiMap.Test_RemovePair_1;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IMultiMap.Test_RemovePair_2;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IMultiMap.Test_TryGetValues_1;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IMultiMap.Test_TryGetValues_2;
begin
  Fail('Not implemented!');
end;

{ TConformance_IBag }

procedure TConformance_IBag.SetUp_ISet(out AEmpty, AOne, AFull: ISet<NativeInt>;
  out AElements: TElements; out AOrdering: TOrdering);
begin
  SetUp_IBag(FEmpty, FOne, FFull, AElements, AOrdering);

  AEmpty := FEmpty;
  AOne := FOne;
  AFull := FFull;
end;

procedure TConformance_IBag.Test_AddWeight;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBag.Test_ContainsWeight;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBag.Test_GetWeight;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBag.Test_RemoveAllWeight;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBag.Test_RemoveWeight;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IBag.Test_SetWeight;
begin
  Fail('Not implemented!');
end;

{ TConformance_ISet }

procedure TConformance_ISet.SetUp_IOperableCollection(out AEmpty, AOne, AFull: IOperableCollection<NativeInt>;
  out AElements: TElements; out AOrdering: TOrdering);
begin
  SetUp_ISet(FEmpty, FOne, FFull, AElements, AOrdering);

  AEmpty := FEmpty;
  AOne := FOne;
  AFull := FFull;
end;

end.
