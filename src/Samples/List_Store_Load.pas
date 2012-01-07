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

(*
   This sample shows a simple case of using the serialization module to first store then load a list from
   a memory stream.
*)
unit List_Store_Load;
interface
uses
  SysUtils,
  Classes,
  Collections.Base,
  Collections.Lists,
  Collections.Serialization;

  ///  <summary>Runs the current sample.</summary>
  procedure RunSample();

{ BIG NOTE: A generic type needs to be specialized in the interface section otherwise the RTTI information
  cannot be obtained at deserialization time and the actual type of the object reference is used. This means that
  if I serialize a X: TCollection<String> -- that is actually a TList<String>, at deserialization a new TList<String> will be
  assembled only if the deserializer can find this type; otherwise the deserializer tries to assemble what it knows -- a TCollection<String>. In
  most cases you will get a serialization error message ...

  The following declaration is required for generic types ... }
type
  TStringList = TList<String>;

implementation


procedure RunSample();
var
  LList: TStringList;
  LSerializer: TSerializer;
  LDeserializer: TDeserializer;
  LStream: TStream;
  LWord: string;
begin
  WriteLn;
  WriteLn('=============== [List_Store_Load] ============ ');
  WriteLn;

  { Create a list filled in with some strings }
  LList := TStringList.Create();
  LList.Add('There');
  LList.Add('is');
  LList.Add('cow');
  LList.Add('eating');
  LList.Add('grass');
  LList.Add('on');
  LList.Add('the');
  LList.Add('field');
  LList.Add('');
  LList.Add('.');

  { Create the stream we are going to write to }
  LStream := TMemoryStream.Create();

  { Obtain a new default serializer }
  LSerializer := TSerializer.Default(LStream);
  try
    { Because the list does store its full capacity it makes sense to first call the Shrink() method to
      remove that extra baggage from the stream. I will not call it because I am lazy! }
    LSerializer.Serialize(LList);
  except
    on E: Exception do
      WriteLn('Serialization of our string list failed with message "', E.Message, '"');
  end;
  LSerializer.Free;

  { Free the list }
  LStream.Seek(0, soFromBeginning);
  FreeAndNil(LList);

  { Now try to de-serialize from that stream. Obtain a de-serializer. }
  LDeserializer := TDeserializer.Default(LStream);
  try
    LList := LDeserializer.Deserialize() as TStringList;
  except
    on E: Exception do
      WriteLn('Deserialization of our string list failed with message "', E.Message, '"');
  end;
  LDeserializer.Free;
  LStream.Free;

  if Assigned(LList) then
  begin
    for LWord in LList do
      Write(LWord, ' ');

    LList.Free;
  end;
end;

end.
