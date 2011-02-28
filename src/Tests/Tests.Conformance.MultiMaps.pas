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
  TConformance_TMultiMap = class(TConformance_IMultiMap)
  published
  end;

  TConformance_TSortedMultiMap = class(TConformance_IMultiMap)
  published
  end;

  TConformance_TDoubleSortedMultiMap = class(TConformance_IMultiMap)
  published
  end;

  TConformance_TDistinctMultiMap = class(TConformance_IMultiMap)
  published
  end;

  TConformance_TSortedDistinctMultiMap = class(TConformance_IMultiMap)
  published
  end;

  TConformance_TDoubleSortedDistinctMultiMap = class(TConformance_IMultiMap)
  published
  end;

type
  TConformance_TMultiMap_Keys = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_TMultiMap_Values = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_TSortedMultiMap_Keys = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_TSortedMultiMap_Values = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_TDoubleSortedMultiMap_Keys = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_TDoubleSortedMultiMap_Values = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_TDistinctMultiMap_Keys = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_TDistinctMultiMap_Values = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_TSortedDistinctMultiMap_Keys = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_TSortedDistinctMultiMap_Values = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_TDoubleSortedDistinctMultiMap_Keys = class(TConformance_IEnexCollection)
  published
  end;

  TConformance_TDoubleSortedDistinctMultiMap_Values = class(TConformance_IEnexCollection)
  published
  end;

implementation

initialization
  RegisterTests('Conformance.Associative.MultiMaps', [
    TConformance_TMultiMap.Suite,
    TConformance_TSortedMultiMap.Suite,
    TConformance_TDoubleSortedMultiMap.Suite,
    TConformance_TDistinctMultiMap.Suite,
    TConformance_TSortedDistinctMultiMap.Suite,
    TConformance_TDoubleSortedDistinctMultiMap.Suite
  ]);

  RegisterTests('Conformance.Simple.Selectors', [
    TConformance_TMultiMap_Keys.Suite,
    TConformance_TMultiMap_Values.Suite,
    TConformance_TSortedMultiMap_Keys.Suite,
    TConformance_TSortedMultiMap_Values.Suite,
    TConformance_TDoubleSortedMultiMap_Keys.Suite,
    TConformance_TDoubleSortedMultiMap_Values.Suite,
    TConformance_TDistinctMultiMap_Keys.Suite,
    TConformance_TDistinctMultiMap_Values.Suite,
    TConformance_TSortedDistinctMultiMap_Keys.Suite,
    TConformance_TSortedDistinctMultiMap_Values.Suite,
    TConformance_TDoubleSortedDistinctMultiMap_Keys.Suite,
    TConformance_TDoubleSortedDistinctMultiMap_Values.Suite
  ]);

end.

