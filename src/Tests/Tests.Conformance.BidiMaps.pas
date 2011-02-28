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

unit Tests.Conformance.BidiMaps;
interface
uses SysUtils,
     Tests.Conformance.Base,
     TestFramework,
     Generics.Collections,
     Collections.Base,
     Collections.BidiMaps;

type
  TConformance_TAbstractBidiMap<TKey, TValue> = class(TConformance_IBidiMap<TKey, TValue>)
  published
  end;

  TConformance_TBidiMap<TKey, TValue> = class(TConformance_IBidiMap<TKey, TValue>)
  published
  end;

  TConformance_TObjectBidiMap<TKey, TValue> = class(TConformance_IBidiMap<TKey, TValue>)
  published
  end;

  TConformance_TSortedBidiMap<TKey, TValue> = class(TConformance_IBidiMap<TKey, TValue>)
  published
  end;

  TConformance_TObjectSortedBidiMap<TKey, TValue> = class(TConformance_IBidiMap<TKey, TValue>)
  published
  end;

  TConformance_TDoubleSortedBidiMap<TKey, TValue> = class(TConformance_IBidiMap<TKey, TValue>)
  published
  end;

  TConformance_TObjectDoubleSortedBidiMap<TKey, TValue> = class(TConformance_IBidiMap<TKey, TValue>)
  published
  end;

type
  TConformance_TAbstractBidiMap_Keys<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TAbstractBidiMap_Values<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TBidiMap_Keys<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TBidiMap_Values<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectBidiMap_Keys<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectBidiMap_Values<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TSortedBidiMap_Keys<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TSortedBidiMap_Values<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectSortedBidiMap_Keys<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectSortedBidiMap_Values<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TDoubleSortedBidiMap_Keys<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TDoubleSortedBidiMap_Values<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectDoubleSortedBidiMap_Keys<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectDoubleSortedBidiMap_Values<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

implementation

initialization
  RegisterTests('Conformance.Associative.BidiMaps.Integer/String', [
    TConformance_TAbstractBidiMap<Integer, String>.Suite,
    TConformance_TBidiMap<Integer, String>.Suite,
    TConformance_TSortedBidiMap<Integer, String>.Suite,
    TConformance_TDoubleSortedBidiMap<Integer, String>.Suite
  ]);
  RegisterTests('Conformance.Associative.BidiMaps.String/Integer', [
    TConformance_TAbstractBidiMap<String, Integer>.Suite,
    TConformance_TBidiMap<String, Integer>.Suite,
    TConformance_TSortedBidiMap<String, Integer>.Suite,
    TConformance_TDoubleSortedBidiMap<String, Integer>.Suite
  ]);
  RegisterTests('Conformance.Associative.BidiMaps.Object/String', [
    TConformance_TObjectBidiMap<TObject, String>.Suite,
    TConformance_TObjectSortedBidiMap<TObject, String>.Suite,
    TConformance_TObjectDoubleSortedBidiMap<TObject, String>.Suite
  ]);
  RegisterTests('Conformance.Associative.BidiMaps.String/Object', [
    TConformance_TObjectBidiMap<String, TObject>.Suite,
    TConformance_TObjectSortedBidiMap<String, TObject>.Suite,
    TConformance_TObjectDoubleSortedBidiMap<String, TObject>.Suite
  ]);

  RegisterTests('Conformance.Simple.Selectors.Integer', [
    TConformance_TAbstractBidiMap_Keys<Integer>.Suite,
    TConformance_TAbstractBidiMap_Values<Integer>.Suite,
    TConformance_TBidiMap_Keys<Integer>.Suite,
    TConformance_TBidiMap_Values<Integer>.Suite,
    TConformance_TSortedBidiMap_Keys<Integer>.Suite,
    TConformance_TSortedBidiMap_Values<Integer>.Suite,
    TConformance_TDoubleSortedBidiMap_Keys<Integer>.Suite,
    TConformance_TDoubleSortedBidiMap_Values<Integer>.Suite
  ]);
  RegisterTests('Conformance.Simple.Selectors.String', [
    TConformance_TAbstractBidiMap_Keys<String>.Suite,
    TConformance_TAbstractBidiMap_Values<String>.Suite,
    TConformance_TBidiMap_Keys<String>.Suite,
    TConformance_TBidiMap_Values<String>.Suite,
    TConformance_TSortedBidiMap_Keys<String>.Suite,
    TConformance_TSortedBidiMap_Values<String>.Suite,
    TConformance_TDoubleSortedBidiMap_Keys<String>.Suite,
    TConformance_TDoubleSortedBidiMap_Values<String>.Suite
  ]);
  RegisterTests('Conformance.Simple.Selectors.Object', [
    TConformance_TObjectBidiMap_Keys<TObject>.Suite,
    TConformance_TObjectBidiMap_Values<TObject>.Suite,
    TConformance_TObjectSortedBidiMap_Keys<TObject>.Suite,
    TConformance_TObjectSortedBidiMap_Values<TObject>.Suite,
    TConformance_TObjectDoubleSortedBidiMap_Keys<TObject>.Suite,
    TConformance_TObjectDoubleSortedBidiMap_Values<TObject>.Suite
  ]);



end.

