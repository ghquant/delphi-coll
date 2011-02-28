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
    procedure Test_FirstWhereLower;
    procedure Test_FirstWhereLowerOrDefault;
    procedure Test_FirstWhereLowerOrEqual;
    procedure Test_FirstWhereLowerOrEqualOrDefault;
    procedure Test_FirstWhereGreater;
    procedure Test_FirstWhereGreaterOrDefault;
    procedure Test_FirstWhereGreaterOrEqual;
    procedure Test_FirstWhereGreaterOrEqualOrDefault;
    procedure Test_FirstWhereBetween;
    procedure Test_FirstWhereBetweenOrDefault;
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
    procedure Test_WhereLower;
    procedure Test_WhereLowerOrEqual;
    procedure Test_WhereGreater;
    procedure Test_WhereGreaterOrEqual;
    procedure Test_WhereBetween;
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
    procedure Test_TakeWhileLower;
    procedure Test_TakeWhileLowerOrEqual;
    procedure Test_TakeWhileGreater;
    procedure Test_TakeWhileGreaterOrEqual;
    procedure Test_TakeWhileBetween;
    procedure Test_Skip;
    procedure Test_SkipWhile;
    procedure Test_SkipWhileLower;
    procedure Test_SkipWhileLowerOrEqual;
    procedure Test_SkipWhileGreater;
    procedure Test_SkipWhileGreaterOrEqual;
    procedure Test_SkipWhileBetween;
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
    procedure Test_WhereKeyLower;
    procedure Test_WhereKeyLowerOrEqual;
    procedure Test_WhereKeyGreater;
    procedure Test_WhereKeyGreaterOrEqual;
    procedure Test_WhereKeyBetween;
    procedure Test_WhereValueLower;
    procedure Test_WhereValueLowerOrEqual;
    procedure Test_WhereValueGreater;
    procedure Test_WhereValueGreaterOrEqual;
    procedure Test_WhereValueBetween;
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

implementation

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
  Fail('Not implemented!');
end;

procedure TConformance_IEnumerable_Simple.Test_Enumerator_ReachEnd;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnumerable_Simple.Test_GetEnumerator;
begin
  Fail('Not implemented!');
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
begin
  Fail('Not implemented!');
end;

procedure TConformance_ICollection_Simple.Test_CopyTo_2;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ICollection_Simple.Test_Empty;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ICollection_Simple.Test_GetCount;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ICollection_Simple.Test_Single;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ICollection_Simple.Test_SingleOrDefault;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ICollection_Simple.Test_ToArray;
begin
  Fail('Not implemented!');
end;

procedure TConformance_ICollection_Simple.Test_Version;
begin
  Fail('Not implemented!');
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
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_AggregateOrDefault;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_All;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Any;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Concat;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Distinct;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_ElementAt;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_ElementAtOrDefault;
begin
  Fail('Not implemented!');
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
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_FirstOrDefault;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_FirstWhere;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_FirstWhereBetween;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_FirstWhereBetweenOrDefault;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_FirstWhereGreater;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_FirstWhereGreaterOrDefault;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_FirstWhereGreaterOrEqual;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_FirstWhereGreaterOrEqualOrDefault;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_FirstWhereLower;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_FirstWhereLowerOrDefault;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_FirstWhereLowerOrEqual;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_FirstWhereLowerOrEqualOrDefault;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_FirstWhereNot;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_FirstWhereNotOrDefault;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_FirstWhereOrDefault;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Intersect;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Last;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_LastOrDefault;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Max;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Min;
begin
  Fail('Not implemented!');
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
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_Skip;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_SkipWhile;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_SkipWhileBetween;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_SkipWhileGreater;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_SkipWhileGreaterOrEqual;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_SkipWhileLower;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_SkipWhileLowerOrEqual;
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

procedure TConformance_IEnexCollection.Test_TakeWhileBetween;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_TakeWhileGreater;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_TakeWhileGreaterOrEqual;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_TakeWhileLower;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_TakeWhileLowerOrEqual;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_ToList;
begin
  Fail('Not implemented!');
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
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_WhereBetween;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_WhereGreater;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_WhereGreaterOrEqual;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_WhereLower;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_WhereLowerOrEqual;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexCollection.Test_WhereNot;
begin
  Fail('Not implemented!');
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

procedure TConformance_IEnexAssociativeCollection.Test_WhereKeyBetween;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_WhereKeyGreater;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_WhereKeyGreaterOrEqual;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_WhereKeyLower;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_WhereKeyLowerOrEqual;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_WhereNot;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_WhereValueBetween;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_WhereValueGreater;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_WhereValueGreaterOrEqual;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_WhereValueLower;
begin
  Fail('Not implemented!');
end;

procedure TConformance_IEnexAssociativeCollection.Test_WhereValueLowerOrEqual;
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
