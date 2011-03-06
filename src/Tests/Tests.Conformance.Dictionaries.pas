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

unit Tests.Conformance.Dictionaries;
interface
uses SysUtils,
     Tests.Conformance.Base,
     TestFramework,
     Generics.Collections,
     Collections.Base,
     Collections.Dictionaries;

type
  TConformance_TDictionary = class(TConformance_IDictionary)
  published
  end;

  TConformance_TLinkedDictionary = class(TConformance_IDictionary)
  published
  end;

  TConformance_TSortedDictionary = class(TConformance_IDictionary)
  published
  end;

type
  TConformance_TDictionary_Keys = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_TDictionary_Values = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_TLinkedDictionary_Keys = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_TLinkedDictionary_Values = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_TSortedDictionary_Keys = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_TSortedDictionary_Values = class(TConformance_IEnexCollection)
  published
  end;

implementation

initialization
  RegisterTests('Conformance.Associative.Dictionaries', [
    TConformance_TDictionary.Suite,
    TConformance_TLinkedDictionary.Suite,
    TConformance_TSortedDictionary.Suite
  ]);

  RegisterTests('Conformance.Simple.Selectors', [
    TConformance_TDictionary_Keys.Suite,
    TConformance_TDictionary_Values.Suite,
    TConformance_TLinkedDictionary_Keys.Suite,
    TConformance_TLinkedDictionary_Values.Suite,
    TConformance_TSortedDictionary_Keys.Suite,
    TConformance_TSortedDictionary_Values.Suite
  ]);

end.

