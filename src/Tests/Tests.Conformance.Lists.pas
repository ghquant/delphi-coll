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

unit Tests.Conformance.Lists;
interface
uses SysUtils,
     Tests.Conformance.Base,
     TestFramework,
     Generics.Collections,
     Collections.Base,
     Collections.Lists;

type
  TConformance_TList = class(TConformance_IList)
  protected
    procedure SetUp_IList(out AEmpty, AOne, AFull: IList<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
  end;

  TConformance_TSortedList = class(TConformance_IList)
  protected
    function GetSortOrder: Boolean; virtual; abstract;
    procedure SetUp_IList(out AEmpty, AOne, AFull: IList<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
  end;

  TConformance_TSortedList_Asc = class(TConformance_TSortedList)
  protected
    function GetSortOrder: Boolean; override;
  end;

  TConformance_TSortedList_Desc = class(TConformance_TSortedList)
  protected
    function GetSortOrder: Boolean; override;
  end;

  TConformance_TLinkedList = class(TConformance_ILinkedList)
  protected
    procedure SetUp_ILinkedList(out AEmpty, AOne, AFull: ILinkedList<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
  published
  end;

  TConformance_TSortedLinkedList = class(TConformance_ILinkedList)
  protected
    function GetSortOrder: Boolean; virtual; abstract;
    procedure SetUp_ILinkedList(out AEmpty, AOne, AFull: ILinkedList<NativeInt>; out AElements: TElements; out AOrdering: TOrdering); override;
  published
  end;

  TConformance_TSortedLinkedList_Asc = class(TConformance_TSortedLinkedList)
  protected
    function GetSortOrder: Boolean; override;
  end;

  TConformance_TSortedLinkedList_Desc = class(TConformance_TSortedLinkedList)
  protected
    function GetSortOrder: Boolean; override;
  end;

implementation

{ TConformance_TList }

procedure TConformance_TList.SetUp_IList(out AEmpty, AOne,
  AFull: IList<NativeInt>; out AElements: TElements; out AOrdering: TOrdering);
var
  LItem: NativeInt;
  LEmpty, LOne, LFull: TList<NativeInt>;
begin
  AElements := GenerateRepeatableRandomElements();
  AOrdering := oInsert;

  LEmpty := TList<NativeInt>.Create(); LEmpty.RemoveNotification := RemoveNotification;
  LOne := TList<NativeInt>.Create(); LOne.RemoveNotification := RemoveNotification;
  LOne.Add(AElements[0]);
  LFull := TList<NativeInt>.Create(); LFull.RemoveNotification := RemoveNotification;

  for LItem in AElements do
    LFull.Add(LItem);

  AEmpty := LEmpty;
  AOne := LOne;
  AFull := LFull;
end;

{ TConformance_TLinkedList }

procedure TConformance_TLinkedList.SetUp_ILinkedList(out AEmpty, AOne,
  AFull: ILinkedList<NativeInt>; out AElements: TElements;
  out AOrdering: TOrdering);
var
  LItem: NativeInt;
  LEmpty, LOne, LFull: TLinkedList<NativeInt>;
begin
  AElements := GenerateRepeatableRandomElements();
  AOrdering := oInsert;

  LEmpty := TLinkedList<NativeInt>.Create(); LEmpty.RemoveNotification := RemoveNotification;
  LOne := TLinkedList<NativeInt>.Create(); LOne.RemoveNotification := RemoveNotification;
  LOne.Add(AElements[0]);
  LFull := TLinkedList<NativeInt>.Create(); LFull.RemoveNotification := RemoveNotification;

  for LItem in AElements do
    LFull.Add(LItem);

  AEmpty := LEmpty;
  AOne := LOne;
  AFull := LFull;
end;

{ TConformance_TSortedList }

procedure TConformance_TSortedList.SetUp_IList(out AEmpty, AOne,
  AFull: IList<NativeInt>; out AElements: TElements; out AOrdering: TOrdering);
var
  LItem: NativeInt;
  LEmpty, LOne, LFull: TSortedList<NativeInt>;
begin
  AElements := GenerateRepeatableRandomElements();

  if GetSortOrder then
    AOrdering := oAscending
  else
    AOrdering := oDescending;

  LEmpty := TSortedList<NativeInt>.Create(TRules<NativeInt>.Default, 0, GetSortOrder); LEmpty.RemoveNotification := RemoveNotification;
  LOne := TSortedList<NativeInt>.Create(TRules<NativeInt>.Default, 0, GetSortOrder); LOne.RemoveNotification := RemoveNotification;
  LOne.Add(AElements[0]);
  LFull := TSortedList<NativeInt>.Create(TRules<NativeInt>.Default, 0, GetSortOrder); LFull.RemoveNotification := RemoveNotification;

  for LItem in AElements do
    LFull.Add(LItem);

  AEmpty := LEmpty;
  AOne := LOne;
  AFull := LFull;
end;

{ TConformance_TSortedList_Asc }

function TConformance_TSortedList_Asc.GetSortOrder: Boolean;
begin
  Result := True;
end;

{ TConformance_TSortedList_Desc }

function TConformance_TSortedList_Desc.GetSortOrder: Boolean;
begin
  Result := False;
end;

{ TConformance_TSortedLinkedList }

procedure TConformance_TSortedLinkedList.SetUp_ILinkedList(out AEmpty, AOne,
  AFull: ILinkedList<NativeInt>; out AElements: TElements;
  out AOrdering: TOrdering);
var
  LItem: NativeInt;
  LEmpty, LOne, LFull: TSortedLinkedList<NativeInt>;
begin
  AElements := GenerateRepeatableRandomElements();

  if GetSortOrder then
    AOrdering := oAscending
  else
    AOrdering := oDescending;

  LEmpty := TSortedLinkedList<NativeInt>.Create(TRules<NativeInt>.Default, GetSortOrder); LEmpty.RemoveNotification := RemoveNotification;
  LOne := TSortedLinkedList<NativeInt>.Create(TRules<NativeInt>.Default, GetSortOrder); LOne.RemoveNotification := RemoveNotification;
  LOne.Add(AElements[0]);
  LFull := TSortedLinkedList<NativeInt>.Create(TRules<NativeInt>.Default, GetSortOrder); LFull.RemoveNotification := RemoveNotification;

  for LItem in AElements do
    LFull.Add(LItem);

  AEmpty := LEmpty;
  AOne := LOne;
  AFull := LFull;
end;

{ TConformance_TSortedLinkedList_Asc }

function TConformance_TSortedLinkedList_Asc.GetSortOrder: Boolean;
begin
  Result := True;
end;

{ TConformance_TSortedLinkedList_Desc }

function TConformance_TSortedLinkedList_Desc.GetSortOrder: Boolean;
begin
  Result := False;
end;

initialization
  RegisterTests('Conformance.Simple.Lists', [
    TConformance_TList.Suite,
    TConformance_TSortedList_Asc.Suite,
    TConformance_TSortedList_Desc.Suite,
    TConformance_TLinkedList.Suite,
    TConformance_TSortedLinkedList_Asc.Suite,
    TConformance_TSortedLinkedList_Desc.Suite
  ]);

end.
