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
  This sample implements a new "collection" based on an input string split by a given character.
  Each element of this "pseudo-collection" is a split part of the string.

  NOTE: This collection is "read-only". We don't implement any higher level interfaces such as IList<T>. This means
        that we don't need an internal versioning scheme and don't need to fear of thread safety issues.
*)
unit SplitStringEnumerable;
interface
uses
  SysUtils,
  Collections.Base;

type
  { A new collection. Derive it from TEnexCollection. Since the elements in our new collection
    are strings (parts of a given initial string) we need to type the generic base as TEnexCollection<string>.}
  TSplitStringCollection = class(TEnexCollection<string>)
  private type

    {
      This is the enumerator. It's a private type in TSplitStringCollection. Noone but this collection
      can instantiate it for ... safety reasons: usually the state is specific and only the collection code
      might be aware of that.

      We derive it from TEnumerator<T>. This type implements IEnumerator<T> and provides some base plumbing code.
    }
    TEnumerator = class(TEnumerator<string>)
    private
      FSPC: TSplitStringCollection;
      FCurrent: string;
      LNowIndex, LPrevIndex, FLength: NativeInt;

    public
      { The contructor. The collection will pass itself here. The enumerator needs to know who is it talking to. }
      constructor Create(const ABaseCollection: TSplitStringCollection);

      { Usual ... Check the implementation for details. }
      destructor Destroy(); override;

      { This one provides the currect "move-next-ed" element. }
      function GetCurrent(): string; override;

      { This method is called prior to anything else. We must return TRUE if the element was obtained, and store that element
        somewhere that GetCurrent can obtain. }
      function MoveNext(): Boolean; override;
    end;

  private
    FInputString: string;
    FSeparator: Char;
    FCount: NativeInt;

  protected
    { Now this is tricky. This function is used by all other function and users to check the length
      of the output collection. We don't know ahead of time ... So we will probably calculate the number of times the separator
      is present in the input string and store that as the count.

      Note that we have overridden thsi method. The deafult implemenation in TEnexCollection<T> will request an enumerator and start
      enumerating till the end of the collection (thus generating the count) -- not very optimal!
    }
    function GetCount(): NativeInt; override;

  public
    { The first constructor is pretty obvious -- requires a string to be split and a character to split by. }
    constructor Create(const AString: string; const ASeparator: Char = ' '); overload;

    { The second contructor also requires a set of comparison rules (the comparer and equality comparer). These rules will be needed for
      Extended operations such as Max() or Min(). The inherited code from TEnexCollection<string> expects us to provide a rules set so we ask the user
      if he has something specific. The first constructor will simply call this cionstructor but request the default rules set (TRules<string>.Default). }
    constructor Create(const ARules: TRules<string>; const AString: string; const ASeparator: Char = ' '); overload;

    { This method will simply check the count to be greater than zero ... that's it. But we need to override it to ensure we have an optimized
     "check for emptiness". Other Enex code will call this method and we can't afford to let the default implementation (it's slow too!). }
    function Empty(): Boolean; override;

    { Even though TEnexCollection<T> provides a Count proprty that calls GetCount() it's better to map to a field if we have one for
      performance reasons.
    }
    property Count: NativeInt read FCount;

    { This is THE MOST IMPORTANT thing you need to provide in your collection. Even GetCount() and Empty() have default implementations in TEnexCollection<T>.
      All those implementations rely on the fact that they extract an enumerator and start playing with it. SO WE ABSOLUTELY MUST provide it ... It's defined as
      abstract anyway so you can't avoid it.
    }
    function GetEnumerator(): IEnumerator<string>; override;
  end;

  { This is the "facade" function. It takes a string and a separator and returns an interface
    reference to a new TSplitStringCollection class that you can play with. }
  function SplitString(const AString: string; const ASeparator: Char = ' '): IEnexCollection<string>;

  ///  <summary>Runs the current sample.</summary>
  procedure RunSample();

implementation

procedure RunSample();
var
  LWord, LInput: string;
  LGroup: IEnexGroupingCollection<Integer, string>;
begin
  WriteLn;
  WriteLn('=============== [SplitStringEnumerable] ============ ');
  WriteLn;

  { Assign some dummy text }
  LInput := 'Johnny had a bad taste in women!';

  { And now let's enjoy the split action. We will split using the default SPACE character effectively
    getting each word. }
  WriteLn('Splitting "', LInput ,'": ');
  for LWord in SplitString(LInput) do
    WriteLn('  # ', LWord);

  WriteLn;

  { And now we will group all words in the string by length. Note that we have 3 "operations involved":
      1. SplitString(LInput) itself which creates the input enumerable.
      2. Op.GroupBy<Integer>(selector) which groups all elements in the input collection by a given "rule".
         In current case the rule is the length of the string. This means that the output of this
         operation is a collection of collections.
      3. Ordered(comparison) which compares a given group to another. This will sort the output in length asceding order.
  }
  WriteLn('Write all words groupped by their length:');
  for LGroup in SplitString(LInput).
    Op.GroupBy<Integer>(function(S: String): Integer begin Exit(Length(S)) end).
    Ordered(function(const L, R: IEnexGroupingCollection<Integer, string>): Integer begin Exit(L.Key - R.Key) end) do
  begin
    { Write the group key (the length) }
    Write('  # ', LGroup.Key, ' characters: ');

    { Now iterate all the words groupped by this length and write them to the console. }
    for LWord in LGroup do
      Write(LWord, ' ');

    { Add a new line for the next group. }
    WriteLn;
  end;
end;

function SplitString(const AString: string; const ASeparator: Char): IEnexCollection<string>;
begin
  { The code is absolutely stupid }
  Result := TSplitStringCollection.Create(AString, ASeparator);
end;

{ TSplitStringCollection }

constructor TSplitStringCollection.Create(const AString: string; const ASeparator: Char);
begin
  { Call the more general constructor. Pass a default rule set along ... }
  Create(TRules<string>.Default, AString, ASeparator);
end;

constructor TSplitStringCollection.Create(const ARules: TRules<string>; const AString: string; const ASeparator: Char);
var
  LChar: Char;
begin
  { This is the core constructor. Step 1 is to call the inherited constructor ans pass the rule set to it.
    It will prepare the collection basics. }
  inherited Create(ARules);

  { The next step is to store the variables }
  FInputString := AString;
  FSeparator := ASeparator;

  { Now we need to check how many split points we will have }

  if Length(AString) > 0 then
  begin
    FCount := 1;

    for LChar in AString do
      if LChar = ASeparator then
        Inc(FCount);

    { Well, that was simple :) }
  end;
end;

function TSplitStringCollection.Empty: Boolean;
begin
  { As promised ... simply check that FCount is bigger than zero }
  Result := FCount > 0;
end;

function TSplitStringCollection.GetCount: NativeInt;
begin
  { Just return the count }
  Result := FCount;
end;

function TSplitStringCollection.GetEnumerator: IEnumerator<string>;
begin
  { Create an enumerator instance and return it as an interface reference. }
  Result := TEnumerator.Create(Self);
end;

{ TSplitStringCollection.TEnumerator }

constructor TSplitStringCollection.TEnumerator.Create(const ABaseCollection: TSplitStringCollection);
begin
  { Store reference to our collection! }
  FSPC := ABaseCollection;

  { This is a quite tricky code to explain.
      The short version: It needs to be here!
      The long version: This function will check if our FSPC (TSplitStringCollection) is simply a
      class reference or it has interface references to it. If there are external interface refs to it
      one will be taken and stored locally somewhere. This is to prevend external code from destroying out parent
      collection while this enumerator is still alive and needs that parent to be alive too. }
  KeepObjectAlive(FSPC);

  { Initialize indexes. }
  LPrevIndex := 1;
  LNowIndex := 1;

  { This if to minimize length calls }
  FLength := Length(FSPC.FInputString);
end;

destructor TSplitStringCollection.TEnumerator.Destroy;
begin
  { This call is optional but will remove the intareface reference we
    have stored for this object (IF WE HAVE STORED ANY!). If the object had no references then this is a NOP. Also it can be simply
    skipped as the inherited destructor will still to the same job ... }
  ReleaseObject(FSPC);

  inherited;
end;

function TSplitStringCollection.TEnumerator.GetCurrent: string;
begin
  { Simply return the string. Don't worry if it might seem uninitialized.
    The enumeration "protocol" says that MoveNext must be called prior to GetCurrent. }
  Result := FCurrent;
end;

function TSplitStringCollection.TEnumerator.MoveNext: Boolean;
begin
  { This is the function that will actually do the work! Wow, we have written so much
    in simple preparation. The code in this method will actually split the string: }

  { Start with a "we are at the end of the world" attitude. }
  Result := false;

  while LNowIndex <= FLength do
  begin
    { Check if the current character is a separator }
    if FSPC.FInputString[LNowIndex] = FSPC.FSeparator then
    begin
      { Yes, we will cut over the required part and place it for the taking }
      FCurrent := System.Copy(FSPC.FInputString, LPrevIndex, (LNowIndex - LPrevIndex));

      { Adjust previous idex so we know where to cut from. }
      LPrevIndex := LNowIndex + 1;

      { We have found the next piece. We might as well just break. }
      Result := true;
    end;

    { Increment the current index. }
    Inc(LNowIndex);

    { If we found a piece exit at this iteration }
    if Result then
      Exit;
  end;

  { Special case! We got here so there is a last split available }
  if LPrevIndex < LNowIndex then
  begin
    { Copy the last peice and mark the result as OK. }
    FCurrent := Copy(FSPC.FInputString, LPrevIndex, FLength - LPrevIndex + 1);
    LPrevIndex := LNowIndex + 1;

    Result := true;
  end;
end;

end.
