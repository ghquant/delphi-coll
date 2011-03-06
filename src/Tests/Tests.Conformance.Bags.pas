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

unit Tests.Conformance.Bags;
interface
uses SysUtils,
     Tests.Conformance.Base,
     TestFramework,
     Generics.Collections,
     Collections.Base,
     Collections.Bags;

type
  TConformance_TBag = class(TConformance_IBag)
  protected
    procedure SetUp_IBag(out AEmpty, AOne, AFull: IBag<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
  end;

  TConformance_TSortedBag = class(TConformance_IBag)
  protected
    function GetSortOrder: Boolean; virtual; abstract;
    procedure SetUp_IBag(out AEmpty, AOne, AFull: IBag<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
  end;

  TConformance_TSortedBag_Asc = class(TConformance_TSortedBag)
  protected
    function GetSortOrder: Boolean; override;
  end;

  TConformance_TSortedBag_Desc = class(TConformance_TSortedBag)
  protected
    function GetSortOrder: Boolean; override;
  end;

implementation

{ TConformance_TBag }

procedure TConformance_TBag.SetUp_IBag(out AEmpty, AOne, AFull: IBag<NativeInt>;
  out AElements: TElements; out AOrdering: TOrdering);
var
  LItem: NativeInt;
  LEmpty, LOne, LFull: TBag<NativeInt>;
begin
  AElements := GenerateRepeatableRandomElements();
  AOrdering := oNone;

  LEmpty := TBag<NativeInt>.Create(); LEmpty.RemoveNotification := RemoveNotification;
  LOne := TBag<NativeInt>.Create(); LOne.RemoveNotification := RemoveNotification;
  LOne.Add(AElements[0]);
  LFull := TBag<NativeInt>.Create(); LFull.RemoveNotification := RemoveNotification;

  for LItem in AElements do
    LFull.Add(LItem);

  AEmpty := LEmpty;
  AOne := LOne;
  AFull := LFull;
end;

{ TConformance_TSortedBag }

procedure TConformance_TSortedBag.SetUp_IBag(out AEmpty, AOne,
  AFull: IBag<NativeInt>; out AElements: TElements; out AOrdering: TOrdering);
var
  LItem: NativeInt;
  LEmpty, LOne, LFull: TSortedBag<NativeInt>;
begin
  AElements := GenerateRepeatableRandomElements();

  if GetSortOrder then
    AOrdering := oAscending
  else
    AOrdering := oDescending;

  LEmpty := TSortedBag<NativeInt>.Create(TRules<NativeInt>.Default, GetSortOrder); LEmpty.RemoveNotification := RemoveNotification;
  LOne := TSortedBag<NativeInt>.Create(TRules<NativeInt>.Default, GetSortOrder); LOne.RemoveNotification := RemoveNotification;
  LOne.Add(AElements[0]);
  LFull := TSortedBag<NativeInt>.Create(TRules<NativeInt>.Default, GetSortOrder); LFull.RemoveNotification := RemoveNotification;

  for LItem in AElements do
    LFull.Add(LItem);

  AEmpty := LEmpty;
  AOne := LOne;
  AFull := LFull;
end;

{ TConformance_TSortedBag_Asc }

function TConformance_TSortedBag_Asc.GetSortOrder: Boolean;
begin
  Result := True;
end;

{ TConformance_TSortedBag_Desc }

function TConformance_TSortedBag_Desc.GetSortOrder: Boolean;
begin
  Result := False;
end;

initialization
  RegisterTests('Conformance.Simple.Bags', [
    TConformance_TBag.Suite,
    TConformance_TSortedBag_Asc.Suite,
    TConformance_TSortedBag_Desc.Suite
  ]);
end.

