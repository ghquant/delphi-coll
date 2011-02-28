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

unit Tests.Conformance.BidiDictionaries;
interface
uses SysUtils,
     Tests.Conformance.Base,
     TestFramework,
     Generics.Collections,
     Collections.Base,
     Collections.Dictionaries;

type
  TConformance_TAbstractBidiDictionary<TKey, TValue> = class(TConformance_IBidiDictionary<TKey, TValue>)
  published
  end;

  TConformance_TBidiDictionary<TKey, TValue> = class(TConformance_IBidiDictionary<TKey, TValue>)
  published
  end;

  TConformance_TObjectBidiDictionary<TKey, TValue> = class(TConformance_IBidiDictionary<TKey, TValue>)
  published
  end;

  TConformance_TSortedBidiDictionary<TKey, TValue> = class(TConformance_IBidiDictionary<TKey, TValue>)
  published
  end;

  TConformance_TObjectSortedBidiDictionary<TKey, TValue> = class(TConformance_IBidiDictionary<TKey, TValue>)
  published
  end;

  TConformance_TDoubleSortedBidiDictionary<TKey, TValue> = class(TConformance_IBidiDictionary<TKey, TValue>)
  published
  end;

  TConformance_TObjectDoubleSortedBidiDictionary<TKey, TValue> = class(TConformance_IBidiDictionary<TKey, TValue>)
  published
  end;


type
  TConformance_TAbstractBidiDictionary_Keys<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TAbstractBidiDictionary_Values<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TBidiDictionary_Keys<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TBidiDictionary_Values<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectBidiDictionary_Keys<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectBidiDictionary_Values<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TSortedBidiDictionary_Keys<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TSortedBidiDictionary_Values<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectSortedBidiDictionary_Keys<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectSortedBidiDictionary_Values<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TDoubleSortedBidiDictionary_Keys<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TDoubleSortedBidiDictionary_Values<T> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectDoubleSortedBidiDictionary_Keys<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;

  TConformance_TObjectDoubleSortedBidiDictionary_Values<T: class> = class(TConformance_IEnexCollection<T>)
  published
  end;


implementation

initialization
  RegisterTests('Conformance.Associative.BidiDictionaries.Integer/String', [
    TConformance_TAbstractBidiDictionary<Integer, String>.Suite,
    TConformance_TBidiDictionary<Integer, String>.Suite,
    TConformance_TSortedBidiDictionary<Integer, String>.Suite,
    TConformance_TDoubleSortedBidiDictionary<Integer, String>.Suite
  ]);
  RegisterTests('Conformance.Associative.BidiDictionaries.String/Integer', [
    TConformance_TAbstractBidiDictionary<String, Integer>.Suite,
    TConformance_TBidiDictionary<String, Integer>.Suite,
    TConformance_TSortedBidiDictionary<String, Integer>.Suite,
    TConformance_TDoubleSortedBidiDictionary<String, Integer>.Suite
  ]);
  RegisterTests('Conformance.Associative.BidiDictionaries.Object/String', [
    TConformance_TObjectBidiDictionary<TObject, String>.Suite,
    TConformance_TObjectSortedBidiDictionary<TObject, String>.Suite,
    TConformance_TObjectDoubleSortedBidiDictionary<TObject, String>.Suite
  ]);
  RegisterTests('Conformance.Associative.BidiDictionaries.String/Object', [
    TConformance_TObjectBidiDictionary<String, TObject>.Suite,
    TConformance_TObjectSortedBidiDictionary<String, TObject>.Suite,
    TConformance_TObjectDoubleSortedBidiDictionary<String, TObject>.Suite
  ]);


  RegisterTests('Conformance.Simple.Selectors.Integer', [
    TConformance_TAbstractBidiDictionary_Keys<Integer>.Suite,
    TConformance_TAbstractBidiDictionary_Values<Integer>.Suite,
    TConformance_TBidiDictionary_Keys<Integer>.Suite,
    TConformance_TBidiDictionary_Values<Integer>.Suite,
    TConformance_TSortedBidiDictionary_Keys<Integer>.Suite,
    TConformance_TSortedBidiDictionary_Values<Integer>.Suite,
    TConformance_TDoubleSortedBidiDictionary_Keys<Integer>.Suite,
    TConformance_TDoubleSortedBidiDictionary_Values<Integer>.Suite
  ]);
  RegisterTests('Conformance.Simple.Selectors.String', [
    TConformance_TAbstractBidiDictionary_Keys<String>.Suite,
    TConformance_TAbstractBidiDictionary_Values<String>.Suite,
    TConformance_TBidiDictionary_Keys<String>.Suite,
    TConformance_TBidiDictionary_Values<String>.Suite,
    TConformance_TSortedBidiDictionary_Keys<String>.Suite,
    TConformance_TSortedBidiDictionary_Values<String>.Suite,
    TConformance_TDoubleSortedBidiDictionary_Keys<String>.Suite,
    TConformance_TDoubleSortedBidiDictionary_Values<String>.Suite
  ]);
  RegisterTests('Conformance.Simple.Selectors.Object', [
    TConformance_TObjectBidiDictionary_Keys<TObject>.Suite,
    TConformance_TObjectBidiDictionary_Values<TObject>.Suite,
    TConformance_TObjectSortedBidiDictionary_Keys<TObject>.Suite,
    TConformance_TObjectSortedBidiDictionary_Values<TObject>.Suite,
    TConformance_TObjectDoubleSortedBidiDictionary_Keys<TObject>.Suite,
    TConformance_TObjectDoubleSortedBidiDictionary_Values<TObject>.Suite
  ]);

end.

