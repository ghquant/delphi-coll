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

unit Tests.Conformance.MultiMaps;
interface
uses SysUtils,
     Tests.Conformance.Base,
     TestFramework,
     Generics.Collections,
     Collections.Base,
     Collections.MultiMaps;

type
  TConformance_TAbstractMultiMap<TKey, TValue> = class(TConformance_IMultiMap<TKey, TValue>)
  published
  end;

  TConformance_TMultiMap<TKey, TValue> = class(TConformance_IMultiMap<TKey, TValue>)
  published
  end;

  TConformance_TObjectMultiMap<TKey, TValue> = class(TConformance_IMultiMap<TKey, TValue>)
  published
  end;

  TConformance_TSortedMultiMap<TKey, TValue> = class(TConformance_IMultiMap<TKey, TValue>)
  published
  end;

  TConformance_TObjectSortedMultiMap<TKey, TValue> = class(TConformance_IMultiMap<TKey, TValue>)
  published
  end;

  TConformance_TDoubleSortedMultiMap<TKey, TValue> = class(TConformance_IMultiMap<TKey, TValue>)
  published
  end;

  TConformance_TObjectDoubleSortedMultiMap<TKey, TValue> = class(TConformance_IMultiMap<TKey, TValue>)
  published
  end;

  TConformance_TDistinctMultiMap<TKey, TValue> = class(TConformance_IMultiMap<TKey, TValue>)
  published
  end;

  TConformance_TObjectDistinctMultiMap<TKey, TValue> = class(TConformance_IMultiMap<TKey, TValue>)
  published
  end;

  TConformance_TSortedDistinctMultiMap<TKey, TValue> = class(TConformance_IMultiMap<TKey, TValue>)
  published
  end;

  TConformance_TObjectSortedDistinctMultiMap<TKey, TValue> = class(TConformance_IMultiMap<TKey, TValue>)
  published
  end;

  TConformance_TDoubleSortedDistinctMultiMap<TKey, TValue> = class(TConformance_IMultiMap<TKey, TValue>)
  published
  end;

  TConformance_TObjectDoubleSortedDistinctMultiMap<TKey, TValue> = class(TConformance_IMultiMap<TKey, TValue>)
  published
  end;

type
  TConformance_TAbstractMultiMap_Keys<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TAbstractMultiMap_Values<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TMultiMap_Keys<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TMultiMap_Values<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectMultiMap_Keys<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectMultiMap_Values<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TSortedMultiMap_Keys<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TSortedMultiMap_Values<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectSortedMultiMap_Keys<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectSortedMultiMap_Values<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TDoubleSortedMultiMap_Keys<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TDoubleSortedMultiMap_Values<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectDoubleSortedMultiMap_Keys<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectDoubleSortedMultiMap_Values<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TAbstractDistinctMultiMap_Values<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TDistinctMultiMap_Keys<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TDistinctMultiMap_Values<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectDistinctMultiMap_Keys<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectDistinctMultiMap_Values<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TSortedDistinctMultiMap_Keys<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TSortedDistinctMultiMap_Values<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectSortedDistinctMultiMap_Keys<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectSortedDistinctMultiMap_Values<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TDoubleSortedDistinctMultiMap_Keys<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TDoubleSortedDistinctMultiMap_Values<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectDoubleSortedDistinctMultiMap_Keys<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectDoubleSortedDistinctMultiMap_Values<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;


implementation

initialization
  RegisterTests('Conformance.Associative.MultiMaps.Integer/String', [
    TConformance_TAbstractMultiMap<Integer, String>.Suite,
    TConformance_TMultiMap<Integer, String>.Suite,
    TConformance_TSortedMultiMap<Integer, String>.Suite,
    TConformance_TDoubleSortedMultiMap<Integer, String>.Suite,
    TConformance_TDistinctMultiMap<Integer, String>.Suite,
    TConformance_TSortedDistinctMultiMap<Integer, String>.Suite,
    TConformance_TDoubleSortedDistinctMultiMap<Integer, String>.Suite
  ]);
  RegisterTests('Conformance.Associative.MultiMaps.String/Integer', [
    TConformance_TAbstractMultiMap<String, Integer>.Suite,
    TConformance_TMultiMap<String, Integer>.Suite,
    TConformance_TSortedMultiMap<String, Integer>.Suite,
    TConformance_TDoubleSortedMultiMap<String, Integer>.Suite,
    TConformance_TDistinctMultiMap<String, Integer>.Suite,
    TConformance_TSortedDistinctMultiMap<String, Integer>.Suite,
    TConformance_TDoubleSortedDistinctMultiMap<String, Integer>.Suite
  ]);
  RegisterTests('Conformance.Associative.MultiMaps.Object/String', [
    TConformance_TObjectMultiMap<TObject, String>.Suite,
    TConformance_TObjectSortedMultiMap<TObject, String>.Suite,
    TConformance_TObjectDoubleSortedMultiMap<TObject, String>.Suite,
    TConformance_TObjectDistinctMultiMap<TObject, String>.Suite,
    TConformance_TObjectSortedDistinctMultiMap<TObject, String>.Suite,
    TConformance_TObjectDoubleSortedDistinctMultiMap<TObject, String>.Suite
  ]);
  RegisterTests('Conformance.Associative.MultiMaps.String/Object', [
    TConformance_TObjectMultiMap<String, TObject>.Suite,
    TConformance_TObjectSortedMultiMap<String, TObject>.Suite,
    TConformance_TObjectDoubleSortedMultiMap<String, TObject>.Suite,
    TConformance_TObjectDistinctMultiMap<String, TObject>.Suite,
    TConformance_TObjectSortedDistinctMultiMap<String, TObject>.Suite,
    TConformance_TObjectDoubleSortedDistinctMultiMap<String, TObject>.Suite
  ]);

  RegisterTests('Conformance.Simple.Selectors.Integer', [
    TConformance_TAbstractMultiMap_Keys<Integer>.Suite,
    TConformance_TAbstractMultiMap_Values<Integer>.Suite,
    TConformance_TMultiMap_Keys<Integer>.Suite,
    TConformance_TMultiMap_Values<Integer>.Suite,
    TConformance_TSortedMultiMap_Keys<Integer>.Suite,
    TConformance_TSortedMultiMap_Values<Integer>.Suite,
    TConformance_TDoubleSortedMultiMap_Keys<Integer>.Suite,
    TConformance_TDoubleSortedMultiMap_Values<Integer>.Suite,
    TConformance_TDistinctMultiMap_Keys<Integer>.Suite,
    TConformance_TDistinctMultiMap_Values<Integer>.Suite,
    TConformance_TSortedDistinctMultiMap_Keys<Integer>.Suite,
    TConformance_TSortedDistinctMultiMap_Values<Integer>.Suite,
    TConformance_TDoubleSortedDistinctMultiMap_Keys<Integer>.Suite,
    TConformance_TDoubleSortedDistinctMultiMap_Values<Integer>.Suite
  ]);
  RegisterTests('Conformance.Simple.Selectors.String', [
    TConformance_TAbstractMultiMap_Keys<String>.Suite,
    TConformance_TAbstractMultiMap_Values<String>.Suite,
    TConformance_TMultiMap_Keys<String>.Suite,
    TConformance_TMultiMap_Values<String>.Suite,
    TConformance_TSortedMultiMap_Keys<String>.Suite,
    TConformance_TSortedMultiMap_Values<String>.Suite,
    TConformance_TDoubleSortedMultiMap_Keys<String>.Suite,
    TConformance_TDoubleSortedMultiMap_Values<String>.Suite,
    TConformance_TDistinctMultiMap_Keys<String>.Suite,
    TConformance_TDistinctMultiMap_Values<String>.Suite,
    TConformance_TSortedDistinctMultiMap_Keys<String>.Suite,
    TConformance_TSortedDistinctMultiMap_Values<String>.Suite,
    TConformance_TDoubleSortedDistinctMultiMap_Keys<String>.Suite,
    TConformance_TDoubleSortedDistinctMultiMap_Values<String>.Suite
  ]);
  RegisterTests('Conformance.Simple.Selectors.Object', [
    TConformance_TObjectMultiMap_Keys<TObject>.Suite,
    TConformance_TObjectMultiMap_Values<TObject>.Suite,
    TConformance_TObjectSortedMultiMap_Keys<TObject>.Suite,
    TConformance_TObjectSortedMultiMap_Values<TObject>.Suite,
    TConformance_TObjectDoubleSortedMultiMap_Keys<TObject>.Suite,
    TConformance_TObjectDoubleSortedMultiMap_Values<TObject>.Suite,
    TConformance_TObjectDistinctMultiMap_Keys<TObject>.Suite,
    TConformance_TObjectDistinctMultiMap_Values<TObject>.Suite,
    TConformance_TObjectSortedDistinctMultiMap_Keys<TObject>.Suite,
    TConformance_TObjectSortedDistinctMultiMap_Values<TObject>.Suite,
    TConformance_TObjectDoubleSortedDistinctMultiMap_Keys<TObject>.Suite,
    TConformance_TObjectDoubleSortedDistinctMultiMap_Values<TObject>.Suite
  ]);

end.

