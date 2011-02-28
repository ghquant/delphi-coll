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
  TConformance_TAbstractOperableCollection = class(TConformance_IOperableCollection)
  published
  end;

  TConformance_TAbstractMap = class(TConformance_IMap)
  published
  end;

  TConformance_IEnexCollection_Op_GroupBy = class(TConformance_IGrouping)
  published
  end;

  TConformance_IEnexCollection_ToList = class(TConformance_IList)
  published
  end;

  TConformance_IEnexCollection_ToSet = class(TConformance_ISet)
  published
  end;

  TConformance_IEnexCollection_Where = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexCollection_Distinct = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexCollection_Ordered_1 = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexCollection_Ordered_2 = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexCollection_Reversed = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexCollection_Concat = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexCollection_Union = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexCollection_Exclude = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexCollection_Intersect = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexCollection_Range = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexCollection_Take = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexCollection_TakeWhile = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexCollection_Skip = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexCollection_SkipWhile = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexCollection_Op_Select_1 = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexCollection_Op_Select_2 = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexCollection_Op_Select_3 = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexCollection_Op_Select_4 = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexCollection_Op_Select_5 = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexAssociativeCollection_ToDictionary = class(TConformance_IDictionary)
  published
  end;

  TConformance_IEnexAssociativeCollection_SelectKeys = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexAssociativeCollection_SelectValues = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_IEnexAssociativeCollection_DistinctByKeys = class(TConformance_IEnexAssociativeCollection)
  published
  end;

  TConformance_IEnexAssociativeCollection_DistinctByValues = class(TConformance_IEnexAssociativeCollection)
  published
  end;

  TConformance_IEnexAssociativeCollection_Where = class(TConformance_IEnexAssociativeCollection)
  published
  end;

implementation

initialization
  RegisterTests('Conformance.Simple.Specific', [
    TConformance_IEnexCollection_ToList.Suite,
    TConformance_IEnexCollection_ToSet.Suite,
    TConformance_IEnexCollection_Where.Suite,
    TConformance_IEnexCollection_Distinct.Suite,
    TConformance_IEnexCollection_Ordered_1.Suite,
    TConformance_IEnexCollection_Ordered_2.Suite,
    TConformance_IEnexCollection_Reversed.Suite,
    TConformance_IEnexCollection_Concat.Suite,
    TConformance_IEnexCollection_Union.Suite,
    TConformance_IEnexCollection_Exclude.Suite,
    TConformance_IEnexCollection_Intersect.Suite,
    TConformance_IEnexCollection_Range.Suite,
    TConformance_IEnexCollection_Take.Suite,
    TConformance_IEnexCollection_TakeWhile.Suite,
    TConformance_IEnexCollection_Skip.Suite,
    TConformance_IEnexCollection_SkipWhile.Suite,
    TConformance_IEnexCollection_Op_Select_1.Suite,
    TConformance_IEnexCollection_Op_Select_2.Suite,
    TConformance_IEnexCollection_Op_Select_3.Suite,
    TConformance_IEnexCollection_Op_Select_4.Suite,
    TConformance_IEnexCollection_Op_Select_5.Suite
  ]);

  RegisterTests('Conformance.Associative.Specific', [
    TConformance_IEnexAssociativeCollection_ToDictionary.Suite,
    TConformance_IEnexAssociativeCollection_SelectKeys.Suite,
    TConformance_IEnexAssociativeCollection_SelectValues.Suite,
    TConformance_IEnexAssociativeCollection_DistinctByKeys.Suite,
    TConformance_IEnexAssociativeCollection_DistinctByValues.Suite,
    TConformance_IEnexAssociativeCollection_Where.Suite
  ]);

end.

