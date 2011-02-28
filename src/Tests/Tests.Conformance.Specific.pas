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

unit Tests.Conformance.Specific;
interface
uses SysUtils,
     Tests.Conformance.Base,
     TestFramework,
     Generics.Collections,
     Collections.Base,
     Collections.Sets;

type
  TConformance_TAbstractOperableCollection<T> = class(TConformance_IOperableCollection<T>)
  published
  end;

  TConformance_TAbstractMap<TKey, TValue> = class(TConformance_IMap<TKey, TValue>)
  published
  end;

  TConformance_IEnexCollection_Op_GroupBy<TKey, T> = class(TConformance_IGrouping<TKey, T>)
  published
  end;

  TConformance_IEnexCollection_ToList<T> = class(TConformance_IList<T>)
  published
  end;

  TConformance_IEnexCollection_ToSet<T> = class(TConformance_ISet<T>)
  published
  end;

  TConformance_IEnexCollection_Where<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_IEnexCollection_Distinct<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_IEnexCollection_Ordered_1<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_IEnexCollection_Ordered_2<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_IEnexCollection_Reversed<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_IEnexCollection_Concat<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_IEnexCollection_Union<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_IEnexCollection_Exclude<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_IEnexCollection_Intersect<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_IEnexCollection_Range<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_IEnexCollection_Take<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_IEnexCollection_TakeWhile<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_IEnexCollection_Skip<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_IEnexCollection_SkipWhile<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_IEnexCollection_Op_Select_1<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_IEnexCollection_Op_Select_2<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_IEnexCollection_Op_Select_3<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_IEnexCollection_Op_Select_4<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_IEnexCollection_Op_Select_5<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_IEnexAssociativeCollection_ToDictionary<TKey, TValue> = class(TConformance_IDictionary<TKey, TValue>)
  published
  end;

  TConformance_IEnexAssociativeCollection_SelectKeys<TKey, TValue> = class(TConformance_IEnexCollection<TKey>)
  published
  end;

  TConformance_IEnexAssociativeCollection_SelectValues<TKey, TValue> = class(TConformance_IEnexCollection<TValue>)
  published
  end;

  TConformance_IEnexAssociativeCollection_DistinctByKeys<TKey, TValue> = class(TConformance_IEnexAssociativeCollection<TKey, TValue>)
  published
  end;

  TConformance_IEnexAssociativeCollection_DistinctByValues<TKey, TValue> = class(TConformance_IEnexAssociativeCollection<TKey, TValue>)
  published
  end;

  TConformance_IEnexAssociativeCollection_Where<TKey, TValue> = class(TConformance_IEnexAssociativeCollection<TKey, TValue>)
  published
  end;

implementation

initialization
  RegisterTests('Conformance.Simple.Specific.Integer', [
    TConformance_TAbstractOperableCollection<Integer>.Suite,
    TConformance_IEnexCollection_ToList<Integer>.Suite,
    TConformance_IEnexCollection_ToSet<Integer>.Suite,
    TConformance_IEnexCollection_Where<Integer>.Suite,
    TConformance_IEnexCollection_Distinct<Integer>.Suite,
    TConformance_IEnexCollection_Ordered_1<Integer>.Suite,
    TConformance_IEnexCollection_Ordered_2<Integer>.Suite,
    TConformance_IEnexCollection_Reversed<Integer>.Suite,
    TConformance_IEnexCollection_Concat<Integer>.Suite,
    TConformance_IEnexCollection_Union<Integer>.Suite,
    TConformance_IEnexCollection_Exclude<Integer>.Suite,
    TConformance_IEnexCollection_Intersect<Integer>.Suite,
    TConformance_IEnexCollection_Range<Integer>.Suite,
    TConformance_IEnexCollection_Take<Integer>.Suite,
    TConformance_IEnexCollection_TakeWhile<Integer>.Suite,
    TConformance_IEnexCollection_Skip<Integer>.Suite,
    TConformance_IEnexCollection_SkipWhile<Integer>.Suite,
    TConformance_IEnexCollection_Op_Select_1<Integer>.Suite,
    TConformance_IEnexCollection_Op_Select_2<Integer>.Suite,
    TConformance_IEnexCollection_Op_Select_3<Integer>.Suite,
    TConformance_IEnexCollection_Op_Select_4<Integer>.Suite,
    TConformance_IEnexCollection_Op_Select_5<Integer>.Suite
  ]);
  RegisterTests('Conformance.Simple.Specific.String', [
    TConformance_TAbstractOperableCollection<String>.Suite,
    TConformance_IEnexCollection_ToList<String>.Suite,
    TConformance_IEnexCollection_ToSet<String>.Suite,
    TConformance_IEnexCollection_Where<String>.Suite,
    TConformance_IEnexCollection_Distinct<String>.Suite,
    TConformance_IEnexCollection_Ordered_1<String>.Suite,
    TConformance_IEnexCollection_Ordered_2<String>.Suite,
    TConformance_IEnexCollection_Reversed<String>.Suite,
    TConformance_IEnexCollection_Concat<String>.Suite,
    TConformance_IEnexCollection_Union<String>.Suite,
    TConformance_IEnexCollection_Exclude<String>.Suite,
    TConformance_IEnexCollection_Intersect<String>.Suite,
    TConformance_IEnexCollection_Range<String>.Suite,
    TConformance_IEnexCollection_Take<String>.Suite,
    TConformance_IEnexCollection_TakeWhile<String>.Suite,
    TConformance_IEnexCollection_Skip<String>.Suite,
    TConformance_IEnexCollection_SkipWhile<String>.Suite,
    TConformance_IEnexCollection_Op_Select_1<String>.Suite,
    TConformance_IEnexCollection_Op_Select_2<String>.Suite,
    TConformance_IEnexCollection_Op_Select_3<String>.Suite,
    TConformance_IEnexCollection_Op_Select_4<String>.Suite,
    TConformance_IEnexCollection_Op_Select_5<String>.Suite
  ]);

  RegisterTests('Conformance.Associative.Specific.Integer/String', [
    TConformance_TAbstractMap<Integer, String>.Suite,
    TConformance_IEnexAssociativeCollection_ToDictionary<Integer, String>.Suite,
    TConformance_IEnexAssociativeCollection_SelectKeys<Integer, String>.Suite,
    TConformance_IEnexAssociativeCollection_SelectValues<Integer, String>.Suite,
    TConformance_IEnexAssociativeCollection_DistinctByKeys<Integer, String>.Suite,
    TConformance_IEnexAssociativeCollection_DistinctByValues<Integer, String>.Suite,
    TConformance_IEnexAssociativeCollection_Where<Integer, String>.Suite
  ]);

  RegisterTests('Conformance.Associative.Specific.String/Integer', [
    TConformance_TAbstractMap<String, Integer>.Suite,
    TConformance_IEnexAssociativeCollection_ToDictionary<String, Integer>.Suite,
    TConformance_IEnexAssociativeCollection_SelectKeys<String, Integer>.Suite,
    TConformance_IEnexAssociativeCollection_SelectValues<String, Integer>.Suite,
    TConformance_IEnexAssociativeCollection_DistinctByKeys<String, Integer>.Suite,
    TConformance_IEnexAssociativeCollection_DistinctByValues<String, Integer>.Suite,
    TConformance_IEnexAssociativeCollection_Where<String, Integer>.Suite
  ]);

end.

