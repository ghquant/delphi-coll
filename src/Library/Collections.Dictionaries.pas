(*
* Copyright (c) 2008-2011, Ciobanu Alexandru
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

unit Collections.Dictionaries;
interface
uses SysUtils,
     Generics.Collections,
     Collections.Base;

type
  ///  <summary>The generic <c>dictionary</c> collection.</summary>
  ///  <remarks>This type uses hashing mechanisms to store its key-value pairs.</remarks>
  TDictionary<TKey, TValue> = class(TEnexAssociativeCollection<TKey, TValue>, IDictionary<TKey, TValue>)
  private type
    {$REGION 'Internal Types'}
    { Generic Dictionary Pairs Enumerator }
    TPairEnumerator = class(TEnumerator<TPair<TKey,TValue>>)
    private
      FVer: NativeInt;
      FDict: TDictionary<TKey, TValue>;
      FCurrentIndex: NativeInt;
      FValue: TPair<TKey,TValue>;

    public
      { Constructor }
      constructor Create(const ADict: TDictionary<TKey, TValue>);

      { Destructor }
      destructor Destroy(); override;

      function GetCurrent(): TPair<TKey,TValue>; override;
      function MoveNext(): Boolean; override;
    end;

    { Generic Dictionary Keys Enumerator }
    TKeyEnumerator = class(TEnumerator<TKey>)
    private
      FVer: NativeInt;
      FDict: TDictionary<TKey, TValue>;
      FCurrentIndex: NativeInt;
      FValue: TKey;
    public
      { Constructor }
      constructor Create(const ADict: TDictionary<TKey, TValue>);

      { Destructor }
      destructor Destroy(); override;

      function GetCurrent(): TKey; override;
      function MoveNext(): Boolean; override;
    end;

    { Generic Dictionary Values Enumerator }
    TValueEnumerator = class(TEnumerator<TValue>)
    private
      FVer: NativeInt;
      FDict: TDictionary<TKey, TValue>;
      FCurrentIndex: NativeInt;
      FValue: TValue;
    public
      { Constructor }
      constructor Create(const ADict: TDictionary<TKey, TValue>);

      { Destructor }
      destructor Destroy(); override;

      function GetCurrent(): TValue; override;
      function MoveNext(): Boolean; override;
    end;

    TEntry = record
      FHashCode: NativeInt;
      FNext: NativeInt;
      FKey: TKey;
      FValue: TValue;
    end;

    TBucketArray = array of NativeInt;
    TEntryArray = TArray<TEntry>;

    { Generic Dictionary Keys Collection }
    TKeyCollection = class(TEnexCollection<TKey>)
    private
      FDict: TDictionary<TKey, TValue>;

    protected
      { Hidden }
      function GetCount(): NativeInt; override;

    public
      { Constructor }
      constructor Create(const ADict: TDictionary<TKey, TValue>);

      { Property }
      property Count: NativeInt read GetCount;

      { IEnumerable/ ICollection support }
      function GetEnumerator(): IEnumerator<TKey>; override;

      { Copy-To }
      procedure CopyTo(var AArray: array of TKey; const AStartIndex: NativeInt); overload; override;
    end;

    { Generic Dictionary Values Collection }
    TValueCollection = class(TEnexCollection<TValue>)
    private
      FDict: TDictionary<TKey, TValue>;

    protected
      { Hidden }
      function GetCount: NativeInt; override;

    public
      { Constructor }
      constructor Create(const ADict: TDictionary<TKey, TValue>);

      { Property }
      property Count: NativeInt read GetCount;

      { IEnumerable/ ICollection support }
      function GetEnumerator(): IEnumerator<TValue>; override;

      { Copy-To }
      procedure CopyTo(var AArray: array of TValue; const AStartIndex: NativeInt); overload; override;
    end;
    {$ENDREGION}

  private var
    FBucketArray: TBucketArray;
    FEntryArray: TEntryArray;
    FKeyCollection: IEnexCollection<TKey>;
    FValueCollection: IEnexCollection<TValue>;
    FCount: NativeInt;
    FFreeCount: NativeInt;
    FFreeList: NativeInt;
    FVer: NativeInt;

    { Internal }
    procedure InitializeInternals(const ACapacity: NativeInt);
    procedure Insert(const AKey: TKey; const AValue: TValue; const ShouldAdd: Boolean = true);
    function FindEntry(const AKey: TKey): NativeInt;
    procedure Resize();
    function Hash(const AKey: TKey): NativeInt;

  protected
    ///  <summary>Returns the number of key-value pairs in the dictionary.</summary>
    ///  <returns>A positive value specifying the number of pairs in the dictionary.</returns>
    function GetCount(): NativeInt; override;

    ///  <summary>Returns the value associated with the given key.</summary>
    ///  <param name="AKey">The key for which to try to retreive the value.</param>
    ///  <returns>The value associated with the key.</returns>
    ///  <exception cref="Collections.Base|EKeyNotFoundException">The key is not found in the dictionary.</exception>
    function GetItem(const AKey: TKey): TValue;

    ///  <summary>Sets the value for a given key.</summary>
    ///  <param name="AKey">The key for which to set the value.</param>
    ///  <param name="AValue">The value to set.</param>
    ///  <remarks>If the dictionary does not contain the key, this method acts like <c>Add</c>; otherwise the
    ///  value of the specified key is modified.</remarks>
    procedure SetItem(const AKey: TKey; const Value: TValue);
  public
    ///  <summary>Creates a new instance of this class.</summary>
    ///  <remarks>The default rule set is requested.</remarks>
    constructor Create(); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AInitialCapacity">The dictionary's initial capacity.</param>
    ///  <remarks>The default rule set is requested.</remarks>
    constructor Create(const AInitialCapacity: NativeInt); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ACollection">A collection to copy pairs from.</param>
    ///  <remarks>The default rule set is requested.</remarks>
    ///  <exception cref="SysUtils|EArgumentNilException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    ///  <exception cref="Collections.Base|EDuplicateKeyException"><paramref name="ACollection"/> contains pairs with equal keys.</exception>
    constructor Create(const ACollection: IEnumerable<TPair<TKey, TValue>>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy pairs from.</param>
    ///  <remarks>The default rule set is requested.</remarks>
    ///  <exception cref="Collections.Base|EDuplicateKeyException"><paramref name="AArray"/> contains pairs with equal keys.</exception>
    constructor Create(const AArray: array of TPair<TKey, TValue>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <exception cref="SysUtils|EArgumentNilException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyRules: TRules<TKey>; const AValueRules: TRules<TValue>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AInitialCapacity">The dictionary's initial capacity.</param>
    ///  <exception cref="SysUtils|EArgumentNilException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyRules: TRules<TKey>; const AValueRules: TRules<TValue>;
      const AInitialCapacity: NativeInt); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ACollection">A collection to copy pairs from.</param>
    ///  <exception cref="SysUtils|EArgumentNilException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    ///  <exception cref="SysUtils|EArgumentNilException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    ///  <exception cref="Collections.Base|EDuplicateKeyException"><paramref name="ACollection"/> contains pairs with equal keys.</exception>
    constructor Create(const AKeyRules: TRules<TKey>; const AValueRules: TRules<TValue>;
      const ACollection: IEnumerable<TPair<TKey, TValue>>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy pairs from.</param>
    ///  <exception cref="SysUtils|EArgumentNilException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    ///  <exception cref="Collections.Base|EDuplicateKeyException"><paramref name="AArray"/> contains pairs with equal keys.</exception>
    constructor Create(const AKeyRules: TRules<TKey>; const AValueRules: TRules<TValue>;
      const AArray: array of TPair<TKey,TValue>); overload;

    ///  <summary>Destroys this instance.</summary>
    ///  <remarks>Do not call this method directly, call <c>Free</c> instead.</remarks>
    destructor Destroy(); override;

    ///  <summary>Clears the contents of the dictionary.</summary>
    ///  <remarks>This method clears the dictionary and invokes rule set's cleaning
    ///  routines for each key and value.</remarks>
    procedure Clear();

    ///  <summary>Adds a key-value pair to the dictionary.</summary>
    ///  <param name="APair">The key-value pair to add.</param>
    ///  <exception cref="Collections.Base|EDuplicateKeyException">The dictionary already contains a pair with the given key.</exception>
    procedure Add(const APair: TPair<TKey,TValue>); overload;

    ///  <summary>Adds a key-value pair to the dictionary.</summary>
    ///  <param name="AKey">The key of pair.</param>
    ///  <param name="AValue">The value associated with the key.</param>
    ///  <exception cref="Collections.Base|EDuplicateKeyException">The dictionary already contains a pair with the given key.</exception>
    procedure Add(const AKey: TKey; const AValue: TValue); overload;

    ///  <summary>Removes a key-value pair using a given key.</summary>
    ///  <param name="AKey">The key of the pair to remove.</param>
    ///  <remarks>This invokes rule set's cleaning routines for value
    ///  associated with the key. If the specified key was not found in the dictionary, nothing happens.</remarks>
    procedure Remove(const AKey: TKey); overload;

    ///  <summary>Checks whether the dictionary contains a key-value pair identified by the given key.</summary>
    ///  <param name="AKey">The key to check for.</param>
    ///  <returns><c>True</c> if the dictionary contains a pair identified by the given key; <c>False</c> otherwise.</returns>
    function ContainsKey(const AKey: TKey): Boolean;

    ///  <summary>Checks whether the dictionary contains a key-value pair that contains a given value.</summary>
    ///  <param name="AValue">The value to check for.</param>
    ///  <returns><c>True</c> if the dictionary contains a pair containing the given value; <c>False</c> otherwise.</returns>
    function ContainsValue(const AValue: TValue): Boolean;

    ///  <summary>Tries to obtain the value associated with a given key.</summary>
    ///  <param name="AKey">The key for which to try to retreive the value.</param>
    ///  <param name="AFoundValue">The found value (if the result is <c>True</c>).</param>
    ///  <returns><c>True</c> if the dictionary contains a value for the given key; <c>False</c> otherwise.</returns>
    function TryGetValue(const AKey: TKey; out AFoundValue: TValue): Boolean;

    ///  <summary>Gets or sets the value for a given key.</summary>
    ///  <param name="AKey">The key for to operate on.</param>
    ///  <returns>The value associated with the key.</returns>
    ///  <remarks>If the dictionary does not contain the key, this method acts like <c>Add</c> if assignment is done to this property;
    ///  otherwise the value of the specified key is modified.</remarks>
    ///  <exception cref="Collections.Base|EKeyNotFoundException">The trying to read the value of a key that is
    ///  not found in the dictionary.</exception>
    property Items[const AKey: TKey]: TValue read GetItem write SetItem; default;

    ///  <summary>Specifies the number of key-value pairs in the dictionary.</summary>
    ///  <returns>A positive value specifying the number of pairs in the dictionary.</returns>
    property Count: NativeInt read GetCount;

    ///  <summary>Specifies the collection that contains only the keys.</summary>
    ///  <returns>An Enex collection that contains all the keys stored in the dictionary.</returns>
    property Keys: IEnexCollection<TKey> read FKeyCollection;

    ///  <summary>Specifies the collection that contains only the values.</summary>
    ///  <returns>An Enex collection that contains all the values stored in the dictionary.</returns>
    property Values: IEnexCollection<TValue> read FValueCollection;

    ///  <summary>Returns a new enumerator object used to enumerate this dictionary.</summary>
    ///  <remarks>This method is usually called by compiler generated code. Its purpose is to create an enumerator
    ///  object that is used to actually traverse the dictionary.</remarks>
    ///  <returns>An enumerator object.</returns>
    function GetEnumerator(): IEnumerator<TPair<TKey,TValue>>; override;

    ///  <summary>Copies the values stored in the dictionary to a given array.</summary>
    ///  <param name="AArray">An array where to copy the contents of the dictionary.</param>
    ///  <param name="AStartIndex">The index into the array at which the copying begins.</param>
    ///  <remarks>This method assumes that <paramref name="AArray"/> has enough space to hold the contents of the dictionary.</remarks>
    ///  <exception cref="SysUtils|EArgumentOutOfRangeException"><paramref name="AStartIndex"/> is out of bounds.</exception>
    ///  <exception cref="Collections.Base|EArgumentOutOfSpaceException">There array is not long enough.</exception>
    procedure CopyTo(var AArray: array of TPair<TKey,TValue>; const AStartIndex: NativeInt); overload; override;

    ///  <summary>Returns the value associated with the given key.</summary>
    ///  <param name="AKey">The key for which to return the associated value.</param>
    ///  <returns>The value associated with the given key.</returns>
    ///  <exception cref="Collections.Base|EKeyNotFoundException">No such key in the dictionary.</exception>
    function ValueForKey(const AKey: TKey): TValue; override;

    ///  <summary>Checks whether the dictionary contains a given key-value pair.</summary>
    ///  <param name="AKey">The key part of the pair.</param>
    ///  <param name="AValue">The value part of the pair.</param>
    ///  <returns><c>True</c> if the given key-value pair exists; <c>False</c> otherwise.</returns>
    function KeyHasValue(const AKey: TKey; const AValue: TValue): Boolean; override;

    ///  <summary>Returns an Enex collection that contains only the keys.</summary>
    ///  <returns>An Enex collection that contains all the keys stored in the dictionary.</returns>
    function SelectKeys(): IEnexCollection<TKey>; override;

    ///  <summary>Returns a Enex collection that contains only the values.</summary>
    ///  <returns>An Enex collection that contains all the values stored in the dictionary.</returns>
    function SelectValues(): IEnexCollection<TValue>; override;
  end;

  ///  <summary>The generic <c>dictionary</c> collection designed to store objects.</summary>
  ///  <remarks>This type uses hashing mechanisms to store its key-value pairs.</remarks>
  TObjectDictionary<TKey, TValue> = class(TDictionary<TKey, TValue>)
  private
    FOwnsKeys, FOwnsValues: Boolean;

  protected
    ///  <summary>Frees the key (object) that was removed from the collection.</summary>
    ///  <param name="AKey">The key that was removed from the collection.</param>
    procedure HandleKeyRemoved(const AKey: TKey); override;

    ///  <summary>Frees the value (object) that was removed from the collection.</summary>
    ///  <param name="AKey">The value that was removed from the collection.</param>
    procedure HandleValueRemoved(const AValue: TValue); override;
  public
    ///  <summary>Specifies whether this dictionary owns the keys.</summary>
    ///  <returns><c>True</c> if the dictionary owns the keys; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the dictionary controls the life-time of the stored keys. The value of
    ///  this property has effect only if the keys are objects, otherwise it is ignored.</remarks>
    property OwnsKeys: Boolean read FOwnsKeys write FOwnsKeys;

    ///  <summary>Specifies whether this dictionary owns the values.</summary>
    ///  <returns><c>True</c> if the dictionary owns the values; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the dictionary controls the life-time of the stored values. The value of
    ///  this property has effect only if the values are objects, otherwise it is ignored.</remarks>
    property OwnsValues: Boolean read FOwnsValues write FOwnsValues;
  end;

type
  ///  <summary>The generic <c>sorted dictionary</c> collection.</summary>
  ///  <remarks>This type uses an AVL-tree to store its key-value pairs.</remarks>
  TSortedDictionary<TKey, TValue> = class(TEnexAssociativeCollection<TKey, TValue>, IDictionary<TKey, TValue>)
  private type
    {$REGION 'Internal Types'}
    TBalanceAct = (baStart, baLeft, baRight, baLoop, baEnd);

    { An internal node class }
    TNode = class
    private
      FKey: TKey;
      FValue: TValue;

      FParent,
       FLeft, FRight: TNode;

      FBalance: ShortInt;
    end;

    { Generic Dictionary Pairs Enumerator }
    TPairEnumerator = class(TEnumerator<TPair<TKey,TValue>>)
    private
      FVer: NativeInt;
      FDict: TSortedDictionary<TKey, TValue>;
      FNext: TNode;
      FValue: TPair<TKey,TValue>;

    public
      { Constructor }
      constructor Create(const ADict: TSortedDictionary<TKey, TValue>);

      { Destructor }
      destructor Destroy(); override;

      function GetCurrent(): TPair<TKey,TValue>; override;
      function MoveNext(): Boolean; override;
    end;

    { Generic Dictionary Keys Enumerator }
    TKeyEnumerator = class(TEnumerator<TKey>)
    private
      FVer: NativeInt;
      FDict: TSortedDictionary<TKey, TValue>;
      FNext: TNode;
      FValue: TKey;

    public
      { Constructor }
      constructor Create(const ADict: TSortedDictionary<TKey, TValue>);

      { Destructor }
      destructor Destroy(); override;

      function GetCurrent(): TKey; override;
      function MoveNext(): Boolean; override;
    end;

    { Generic Dictionary Values Enumerator }
    TValueEnumerator = class(TEnumerator<TValue>)
    private
      FVer: NativeInt;
      FDict: TSortedDictionary<TKey, TValue>;
      FNext: TNode;
      FValue: TValue;

    public
      { Constructor }
      constructor Create(const ADict: TSortedDictionary<TKey, TValue>);

      { Destructor }
      destructor Destroy(); override;

      function GetCurrent(): TValue; override;
      function MoveNext(): Boolean; override;
    end;

    { Generic Dictionary Keys Collection }
    TKeyCollection = class(TEnexCollection<TKey>)
    private
      FDict: TSortedDictionary<TKey, TValue>;

    protected
      { Hidden }
      function GetCount(): NativeInt; override;

    public
      { Constructor }
      constructor Create(const ADict: TSortedDictionary<TKey, TValue>);

      { Property }
      property Count: NativeInt read GetCount;

      { IEnumerable/ ICollection support }
      function GetEnumerator(): IEnumerator<TKey>; override;

      { Copy-To }
      procedure CopyTo(var AArray: array of TKey; const AStartIndex: NativeInt); overload; override;
    end;

    { Generic Dictionary Values Collection }
    TValueCollection = class(TEnexCollection<TValue>)
    private
      FDict: TSortedDictionary<TKey, TValue>;

    protected
      { Hidden }
      function GetCount: NativeInt; override;

    public
      { Constructor }
      constructor Create(const ADict: TSortedDictionary<TKey, TValue>);

      { Property }
      property Count: NativeInt read GetCount;

      { IEnumerable/ ICollection support }
      function GetEnumerator(): IEnumerator<TValue>; override;

      { Copy-To }
      procedure CopyTo(var AArray: array of TValue; const AStartIndex: NativeInt); overload; override;
    end;
    {$ENDREGION}

  private var
    FCount: NativeInt;
    FVer: NativeInt;
    FRoot: TNode;
    FSignFix: NativeInt;
    FKeyCollection: IEnexCollection<TKey>;
    FValueCollection: IEnexCollection<TValue>;

    { Some internals }
    function FindNodeWithKey(const AKey: TKey): TNode;
    function FindLeftMostNode(): TNode;
    function FindRightMostNode(): TNode;
    function WalkToTheRight(const ANode: TNode): TNode;

    { ... }
    function MakeNode(const AKey: TKey; const AValue: TValue; const ARoot: TNode): TNode;
    procedure RecursiveClear(const ANode: TNode);
    procedure ReBalanceSubTreeOnInsert(const ANode: TNode);
    function Insert(const AKey: TKey; const AValue: TValue; const ChangeOrFail: Boolean): Boolean;

    { Removal }
    procedure BalanceTreesAfterRemoval(const ANode: TNode);
  protected
    ///  <summary>Returns the number of key-value pairs in the dictionary.</summary>
    ///  <returns>A positive value specifying the number of pairs in the dictionary.</returns>
    function GetCount(): NativeInt; override;

    ///  <summary>Returns the value associated with the given key.</summary>
    ///  <param name="AKey">The key for which to try to retreive the value.</param>
    ///  <returns>The value associated with the key.</returns>
    ///  <exception cref="Collections.Base|EKeyNotFoundException">The key is not found in the dictionary.</exception>
    function GetItem(const AKey: TKey): TValue;

    ///  <summary>Sets the value for a given key.</summary>
    ///  <param name="AKey">The key for which to set the value.</param>
    ///  <param name="AValue">The value to set.</param>
    ///  <remarks>If the dictionary does not contain the key, this method acts like <c>Add</c>; otherwise the
    ///  value of the specified key is modified.</remarks>
    procedure SetItem(const AKey: TKey; const Value: TValue);
  public
    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AAscending">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <remarks>The default rule set is requested.</remarks>
    constructor Create(const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ACollection">A collection to copy the key-value pairs from.</param>
    ///  <param name="AAscending">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <remarks>The default rule set is requested.</remarks>
    ///  <exception cref="SysUtils|EArgumentNilException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    ///  <exception cref="Collections.Base|EDuplicateKeyException"><paramref name="ACollection"/> contains pairs with equal keys.</exception>
    constructor Create(const ACollection: IEnumerable<TPair<TKey,TValue>>; const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy the key-value pairs from.</param>
    ///  <param name="AAscending">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <remarks>The default rule set is requested.</remarks>
    ///  <exception cref="Collections.Base|EDuplicateKeyException"><paramref name="AArray"/> contains pairs with equal keys.</exception>
    constructor Create(const AArray: array of TPair<TKey,TValue>; const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyRules">The rule set describing the keys.</param>
    ///  <param name="AValueRules">The rule set describing the values.</param>
    ///  <param name="AAscending">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <exception cref="SysUtils|EArgumentNilException"><paramref name="AKeyRules"/> is <c>nil</c>.</exception>
    ///  <exception cref="SysUtils|EArgumentNilException"><paramref name="AValueRules"/> is <c>nil</c>.</exception>
    constructor Create(const AKeyRules: TRules<TKey>; const AValueRules: TRules<TValue>;
      const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyRules">The rule set describing the keys.</param>
    ///  <param name="AValueRules">The rule set describing the values.</param>
    ///  <param name="ACollection">A collection to copy the key-value pairs from.</param>
    ///  <param name="AAscending">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <exception cref="SysUtils|EArgumentNilException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    ///  <exception cref="SysUtils|EArgumentNilException"><paramref name="AKeyRules"/> is <c>nil</c>.</exception>
    ///  <exception cref="SysUtils|EArgumentNilException"><paramref name="AValueRules"/> is <c>nil</c>.</exception>
    ///  <exception cref="Collections.Base|EDuplicateKeyException"><paramref name="ACollection"/> contains pairs with equal keys.</exception>
    constructor Create(const AKeyRules: TRules<TKey>; const AValueRules: TRules<TValue>;
      const ACollection: IEnumerable<TPair<TKey,TValue>>; const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AKeyRules">The rule set describing the keys.</param>
    ///  <param name="AValueRules">The rule set describing the values.</param>
    ///  <param name="AArray">An array to copy the key-value pairs from.</param>
    ///  <param name="AAscending">A value specifying whether the keys are sorted in asceding order. Default is <c>True</c>.</param>
    ///  <exception cref="SysUtils|EArgumentNilException"><paramref name="AKeyRules"/> is <c>nil</c>.</exception>
    ///  <exception cref="SysUtils|EArgumentNilException"><paramref name="AValueRules"/> is <c>nil</c>.</exception>
    ///  <exception cref="Collections.Base|EDuplicateKeyException"><paramref name="AArray"/> contains pairs with equal keys.</exception>
    constructor Create(const AKeyRules: TRules<TKey>; const AValueRules: TRules<TValue>;
      const AArray: array of TPair<TKey,TValue>; const AAscending: Boolean = true); overload;

    ///  <summary>Destroys this instance.</summary>
    ///  <remarks>Do not call this method directly, call <c>Free</c> instead.</remarks>
    destructor Destroy(); override;

    ///  <summary>Clears the contents of the dictionary.</summary>
    ///  <remarks>This method clears the dictionary and invokes rule set's cleaning
    ///  routines for each key and value.</remarks>
    procedure Clear();

    ///  <summary>Adds a key-value pair to the dictionary.</summary>
    ///  <param name="APair">The key-value pair to add.</param>
    ///  <exception cref="Collections.Base|EDuplicateKeyException">The dictionary already contains a pair with the given key.</exception>
    procedure Add(const APair: TPair<TKey,TValue>); overload;

    ///  <summary>Adds a key-value pair to the dictionary.</summary>
    ///  <param name="AKey">The key of pair.</param>
    ///  <param name="AValue">The value associated with the key.</param>
    ///  <exception cref="Collections.Base|EDuplicateKeyException">The dictionary already contains a pair with the given key.</exception>
    procedure Add(const AKey: TKey; const AValue: TValue); overload;

    ///  <summary>Removes a key-value pair using a given key.</summary>
    ///  <param name="AKey">The key of the pair to remove.</param>
    ///  <remarks>This invokes rule set's cleaning routines for value
    ///  associated with the key. If the specified key was not found in the dictionary, nothing happens.</remarks>
    procedure Remove(const AKey: TKey); overload;

    ///  <summary>Checks whether the dictionary contains a key-value pair identified by the given key.</summary>
    ///  <param name="AKey">The key to check for.</param>
    ///  <returns><c>True</c> if the dictionary contains a pair identified by the given key; <c>False</c> otherwise.</returns>
    function ContainsKey(const AKey: TKey): Boolean;

    ///  <summary>Checks whether the dictionary contains a key-value pair that contains a given value.</summary>
    ///  <param name="AValue">The value to check for.</param>
    ///  <returns><c>True</c> if the dictionary contains a pair containing the given value; <c>False</c> otherwise.</returns>
    function ContainsValue(const AValue: TValue): Boolean;

    ///  <summary>Tries to obtain the value associated with a given key.</summary>
    ///  <param name="AKey">The key for which to try to retreive the value.</param>
    ///  <param name="AFoundValue">The found value (if the result is <c>True</c>).</param>
    ///  <returns><c>True</c> if the dictionary contains a value for the given key; <c>False</c> otherwise.</returns>
    function TryGetValue(const AKey: TKey; out AFoundValue: TValue): Boolean;

    ///  <summary>Gets or sets the value for a given key.</summary>
    ///  <param name="AKey">The key for to operate on.</param>
    ///  <returns>The value associated with the key.</returns>
    ///  <remarks>If the dictionary does not contain the key, this method acts like <c>Add</c> if assignment is done to this property;
    ///  otherwise the value of the specified key is modified.</remarks>
    ///  <exception cref="Collections.Base|EKeyNotFoundException">The trying to read the value of a key that is
    ///  not found in the dictionary.</exception>
    property Items[const AKey: TKey]: TValue read GetItem write SetItem; default;

    ///  <summary>Specifies the number of key-value pairs in the dictionary.</summary>
    ///  <returns>A positive value specifying the number of pairs in the dictionary.</returns>
    property Count: NativeInt read GetCount;

    ///  <summary>Specifies the collection that contains only the keys.</summary>
    ///  <returns>An Enex collection that contains all the keys stored in the dictionary.</returns>
    property Keys: IEnexCollection<TKey> read FKeyCollection;

    ///  <summary>Specifies the collection that contains only the values.</summary>
    ///  <returns>An Enex collection that contains all the values stored in the dictionary.</returns>
    property Values: IEnexCollection<TValue> read FValueCollection;

    ///  <summary>Returns a new enumerator object used to enumerate this dictionary.</summary>
    ///  <remarks>This method is usually called by compiler generated code. Its purpose is to create an enumerator
    ///  object that is used to actually traverse the dictionary.</remarks>
    ///  <returns>An enumerator object.</returns>
    function GetEnumerator(): IEnumerator<TPair<TKey,TValue>>; override;

    ///  <summary>Copies the values stored in the dictionary to a given array.</summary>
    ///  <param name="AArray">An array where to copy the contents of the dictionary.</param>
    ///  <param name="AStartIndex">The index into the array at which the copying begins.</param>
    ///  <remarks>This method assumes that <paramref name="AArray"/> has enough space to hold the contents of the dictionary.</remarks>
    ///  <exception cref="SysUtils|EArgumentOutOfRangeException"><paramref name="AStartIndex"/> is out of bounds.</exception>
    ///  <exception cref="Collections.Base|EArgumentOutOfSpaceException">There array is not long enough.</exception>
    procedure CopyTo(var AArray: array of TPair<TKey,TValue>; const AStartIndex: NativeInt); overload; override;

    ///  <summary>Returns the value associated with the given key.</summary>
    ///  <param name="AKey">The key for which to return the associated value.</param>
    ///  <returns>The value associated with the given key.</returns>
    ///  <exception cref="Collections.Base|EKeyNotFoundException">No such key in the dictionary.</exception>
    function ValueForKey(const AKey: TKey): TValue; override;

    ///  <summary>Checks whether the dictionary contains a given key-value pair.</summary>
    ///  <param name="AKey">The key part of the pair.</param>
    ///  <param name="AValue">The value part of the pair.</param>
    ///  <returns><c>True</c> if the given key-value pair exists; <c>False</c> otherwise.</returns>
    function KeyHasValue(const AKey: TKey; const AValue: TValue): Boolean; override;

    ///  <summary>Returns the biggest key.</summary>
    ///  <returns>The biggest key stored in the dictionary.</returns>
    ///  <exception cref="Collections.Base|ECollectionEmptyException">The dictionary is empty.</exception>
    function MaxKey(): TKey; override;

    ///  <summary>Returns the smallest key.</summary>
    ///  <returns>The smallest key stored in the dictionary.</returns>
    ///  <exception cref="Collections.Base|ECollectionEmptyException">The dictionary is empty.</exception>
    function MinKey(): TKey; override;

    ///  <summary>Returns an Enex collection that contains only the keys.</summary>
    ///  <returns>An Enex collection that contains all the keys stored in the dictionary.</returns>
    function SelectKeys(): IEnexCollection<TKey>; override;

    ///  <summary>Returns a Enex collection that contains only the values.</summary>
    ///  <returns>An Enex collection that contains all the values stored in the dictionary.</returns>
    function SelectValues(): IEnexCollection<TValue>; override;
  end;

  ///  <summary>The generic <c>sorted dictionary</c> collection designed to store objects.</summary>
  ///  <remarks>This type uses an AVL-tree to store its key-value pairs.</remarks>
  TObjectSortedDictionary<TKey, TValue> = class(TSortedDictionary<TKey, TValue>)
  private
    FOwnsKeys, FOwnsValues: Boolean;

  protected
    ///  <summary>Frees the key (object) that was removed from the collection.</summary>
    ///  <param name="AKey">The key that was removed from the collection.</param>
    procedure HandleKeyRemoved(const AKey: TKey); override;

    ///  <summary>Frees the value (object) that was removed from the collection.</summary>
    ///  <param name="AKey">The value that was removed from the collection.</param>
    procedure HandleValueRemoved(const AValue: TValue); override;
  public
    ///  <summary>Specifies whether this dictionary owns the keys.</summary>
    ///  <returns><c>True</c> if the dictionary owns the keys; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the dictionary controls the life-time of the stored keys. The value of
    ///  this property has effect only if the keys are objects, otherwise it is ignored.</remarks>
    property OwnsKeys: Boolean read FOwnsKeys write FOwnsKeys;

    ///  <summary>Specifies whether this dictionary owns the values.</summary>
    ///  <returns><c>True</c> if the dictionary owns the values; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the dictionary controls the life-time of the stored values. The value of
    ///  this property has effect only if the values are objects, otherwise it is ignored.</remarks>
    property OwnsValues: Boolean read FOwnsValues write FOwnsValues;
  end;

implementation

{ TDictionary<TKey, TValue> }

procedure TDictionary<TKey, TValue>.Add(const APair: TPair<TKey, TValue>);
begin
 { Call insert }
 Insert(APair.Key, APair.Value);
end;

procedure TDictionary<TKey, TValue>.Add(const AKey: TKey; const AValue: TValue);
begin
 { Call insert }
 Insert(AKey, AValue);
end;

procedure TDictionary<TKey, TValue>.Clear;
var
  I, K: NativeInt;
begin
  if FCount > 0 then
    for I := 0 to Length(FBucketArray) - 1 do
      FBucketArray[I] := -1;

  for I := 0 to Length(FEntryArray) - 1 do
  begin
    if FEntryArray[I].FHashCode >= 0 then
    begin
      NotifyKeyRemoved(FEntryArray[I].FKey);
      FEntryArray[I].FKey := default(TKey);

      NotifyValueRemoved(FEntryArray[I].FValue);
      FEntryArray[I].FValue := default(TValue);
    end;
  end;

  FillChar(FEntryArray[0], Length(FEntryArray) * SizeOf(TEntry), 0);

  FFreeList := -1;
  FCount := 0;
  FFreeCount := 0;

  Inc(FVer);
end;

function TDictionary<TKey, TValue>.ContainsKey(const AKey: TKey): Boolean;
begin
  Result := (FindEntry(AKey) >= 0);
end;

function TDictionary<TKey, TValue>.ContainsValue(const AValue: TValue): Boolean;
var
  I: NativeInt;
begin
  Result := False;

  for I := 0 to FCount - 1 do
  begin
    if (FEntryArray[I].FHashCode >= 0) and (ValueRules.AreEqual(FEntryArray[I].FValue, AValue)) then
       begin Result := True; Exit; end;

  end;
end;

procedure TDictionary<TKey, TValue>.CopyTo(var AArray: array of TPair<TKey, TValue>; const AStartIndex: NativeInt);
var
  I, X: NativeInt;
begin
  { Check for indexes }
  if (AStartIndex >= Length(AArray)) or (AStartIndex < 0) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  if (Length(AArray) - AStartIndex) < Count then
     ExceptionHelper.Throw_ArgumentOutOfSpaceError('AArray');

  X := AStartIndex;

  for I := 0 to FCount - 1 do
  begin
    if (FEntryArray[I].FHashCode >= 0) then
    begin
       AArray[X].Key := FEntryArray[I].FKey;
       AArray[X].Value := FEntryArray[I].FValue;

       Inc(X);
    end;
  end;
end;

constructor TDictionary<TKey, TValue>.Create;
begin
  Create(TRules<TKey>.Default, TRules<TValue>.Default);
end;

constructor TDictionary<TKey, TValue>.Create(const AInitialCapacity: NativeInt);
begin
  Create(TRules<TKey>.Default, TRules<TValue>.Default, AInitialCapacity);
end;

constructor TDictionary<TKey, TValue>.Create(
  const ACollection: IEnumerable<TPair<TKey, TValue>>);
begin
  Create(TRules<TKey>.Default, TRules<TValue>.Default, ACollection);
end;

constructor TDictionary<TKey, TValue>.Create(
  const AKeyRules: TRules<TKey>;
  const AValueRules: TRules<TValue>; const AInitialCapacity: NativeInt);
begin
  { Call the upper constructor }
  inherited Create(AKeyRules, AValueRules);

  FKeyCollection := TKeyCollection.Create(Self);
  FValueCollection := TValueCollection.Create(Self);

  FVer := 0;
  FCount := 0;
  FFreeCount := 0;
  FFreeList := 0;

  InitializeInternals(AInitialCapacity);
end;

constructor TDictionary<TKey, TValue>.Create(const AKeyRules: TRules<TKey>;
  const AValueRules: TRules<TValue>;
  const ACollection: IEnumerable<TPair<TKey, TValue>>);
var
  V: TPair<TKey, TValue>;
begin
  { Call upper constructor }
  Create(AKeyRules, AValueRules, CDefaultSize);

  if (ACollection = nil) then
     ExceptionHelper.Throw_ArgumentNilError('ACollection');

  { Pump in all items }
  for V in ACollection do
  begin
{$IF CompilerVersion < 22}
    Add(V);
{$ELSE}
    Add(V.Key, V.Value);
{$IFEND}
  end;
end;

constructor TDictionary<TKey, TValue>.Create(
  const AKeyRules: TRules<TKey>;
  const AValueRules: TRules<TValue>);
begin
  { Call upper constructor }
  Create(AKeyRules, AValueRules, CDefaultSize);
end;

destructor TDictionary<TKey, TValue>.Destroy;
begin
  { Clear first }
  Clear();

  inherited;
end;

function TDictionary<TKey, TValue>.FindEntry(const AKey: TKey): NativeInt;
var
  HashCode: NativeInt;
  I       : NativeInt;
begin
  Result := -1;

  if Length(FBucketArray) > 0 then
  begin
    { Generate the hash code }
    HashCode := Hash(AKey);

    I := FBucketArray[HashCode mod Length(FBucketArray)];

    while I >= 0 do
    begin
      if (FEntryArray[I].FHashCode = HashCode) and KeyRules.AreEqual(FEntryArray[I].FKey, AKey) then
         begin Result := I; Exit; end;

      I := FEntryArray[I].FNext;
    end;
  end;
end;

function TDictionary<TKey, TValue>.GetCount: NativeInt;
begin
  Result := (FCount - FFreeCount);
end;

function TDictionary<TKey, TValue>.GetEnumerator: IEnumerator<TPair<TKey, TValue>>;
begin
  Result := TDictionary<TKey, TValue>.TPairEnumerator.Create(Self);
end;

function TDictionary<TKey, TValue>.GetItem(const AKey: TKey): TValue;
begin
  if not TryGetValue(AKey, Result) then
    ExceptionHelper.Throw_KeyNotFoundError('AKey');
end;

function TDictionary<TKey, TValue>.Hash(const AKey: TKey): NativeInt;
const
  PositiveMask = not NativeInt(1 shl (SizeOf(NativeInt) * 8 - 1));
begin
  Result := PositiveMask and ((PositiveMask and KeyRules.GetHashCode(AKey)) + 1);
end;

procedure TDictionary<TKey, TValue>.InitializeInternals(
  const ACapacity: NativeInt);
var
  I: NativeInt;
begin
  SetLength(FBucketArray, ACapacity);
  SetLength(FEntryArray, ACapacity);

  for I := 0 to ACapacity - 1 do
  begin
    FBucketArray[I] := -1;
    FEntryArray[I].FHashCode := -1;
  end;

  FFreeList := -1;
end;

procedure TDictionary<TKey, TValue>.Insert(const AKey: TKey;
  const AValue: TValue; const ShouldAdd: Boolean);
var
  FreeList, Index,
    HashCode, I: NativeInt;
begin
  FreeList := 0;

  if Length(FBucketArray) = 0 then
     InitializeInternals(0);

  { Generate the hash code }
  HashCode := Hash(AKey);
  Index := HashCode mod Length(FBucketArray);

  I := FBucketArray[Index];

  while I >= 0 do
  begin
    if (FEntryArray[I].FHashCode = HashCode) and KeyRules.AreEqual(FEntryArray[I].FKey, AKey) then
    begin
      if (ShouldAdd) then
        ExceptionHelper.Throw_DuplicateKeyError('AKey');

      FEntryArray[I].FValue := AValue;
      Inc(FVer);
      Exit;
    end;

    { Move to next }
    I := FEntryArray[I].FNext;
  end;

  { Adjust free spaces }
  if FFreeCount > 0 then
  begin
    FreeList := FFreeList;
    FFreeList := FEntryArray[FreeList].FNext;

    Dec(FFreeCount);
  end else
  begin
    { Adjust index if there is not enough free space }
    if FCount = Length(FEntryArray) then
    begin
      Resize();
      Index := HashCode mod Length(FBucketArray);
    end;

    FreeList := FCount;
    Inc(FCount);
  end;

  { Insert the element at the right position and adjust arrays }
  FEntryArray[FreeList].FHashCode := HashCode;
  FEntryArray[FreeList].FKey := AKey;
  FEntryArray[FreeList].FValue := AValue;
  FEntryArray[FreeList].FNext := FBucketArray[Index];

  FBucketArray[Index] := FreeList;
  Inc(FVer);
end;

function TDictionary<TKey, TValue>.KeyHasValue(const AKey: TKey; const AValue: TValue): Boolean;
var
  LValue: TValue;
begin
  Result := TryGetValue(AKey, LValue) and ValueRules.AreEqual(LValue, AValue);
end;

procedure TDictionary<TKey, TValue>.Remove(const AKey: TKey);
var
  HashCode: NativeInt;
  Index   : NativeInt;
  I       : NativeInt;
  RemIndex: NativeInt;
begin
  if Length(FBucketArray) > 0 then
  begin
    { Generate the hash code }
    HashCode := Hash(AKey);

    Index := HashCode mod Length(FBucketArray);
    RemIndex := -1;

    I := FBucketArray[Index];

    while I >= 0 do
    begin
      if (FEntryArray[I].FHashCode = HashCode) and KeyRules.AreEqual(FEntryArray[I].FKey, AKey) then
      begin

        if RemIndex < 0 then
          FBucketArray[Index] := FEntryArray[I].FNext
        else
          FEntryArray[RemIndex].FNext := FEntryArray[I].FNext;

        { Cleanup required? }
        NotifyValueRemoved(FEntryArray[I].FValue);

        FEntryArray[I].FHashCode := -1;
        FEntryArray[I].FNext := FFreeList;
        FEntryArray[I].FKey := default(TKey);
        FEntryArray[I].FValue := default(TValue);

        FFreeList := I;
        Inc(FFreeCount);
        Inc(FVer);

        Exit;
      end;

      RemIndex := I;
      I := FEntryArray[I].FNext;
    end;

  end;
end;

procedure TDictionary<TKey, TValue>.Resize;
var
  LNewLength, I, LIndex: NativeInt;
begin
  LNewLength := FCount * 2;

  SetLength(FBucketArray, LNewLength);
  SetLength(FEntryArray, LNewLength);

  for I := 0 to LNewLength - 1 do
    FBucketArray[I] := -1;

  for I := 0 to FCount - 1 do
  begin
    LIndex := FEntryArray[I].FHashCode mod LNewLength;
    FEntryArray[I].FNext := FBucketArray[LIndex];
    FBucketArray[LIndex] := I;
  end;
end;

function TDictionary<TKey, TValue>.SelectKeys: IEnexCollection<TKey>;
begin
  Result := Keys;
end;

function TDictionary<TKey, TValue>.SelectValues: IEnexCollection<TValue>;
begin
  Result := Values;
end;

procedure TDictionary<TKey, TValue>.SetItem(const AKey: TKey;
  const Value: TValue);
begin
  { Simply call insert }
  Insert(AKey, Value, false);
end;

function TDictionary<TKey, TValue>.TryGetValue(const AKey: TKey; out AFoundValue: TValue): Boolean;
var
  Index: NativeInt;
begin
  Index := FindEntry(AKey);

  if Index >= 0 then
     begin
       AFoundValue := FEntryArray[Index].FValue;
       Exit(True);
     end;

  { Key not found, simply fail }
  AFoundValue := Default(TValue);
  Result := False;
end;

function TDictionary<TKey, TValue>.ValueForKey(const AKey: TKey): TValue;
begin
  Result := GetItem(AKey);
end;

constructor TDictionary<TKey, TValue>.Create(
  const AArray: array of TPair<TKey, TValue>);
begin
  Create(TRules<TKey>.Default, TRules<TValue>.Default, AArray);
end;

constructor TDictionary<TKey, TValue>.Create(
  const AKeyRules: TRules<TKey>;
  const AValueRules: TRules<TValue>;
  const AArray: array of TPair<TKey, TValue>);
var
  I: NativeInt;
begin
  { Call upper constructor }
  Create(AKeyRules, AValueRules, CDefaultSize);

  { Copy all items in }
  for I := 0 to Length(AArray) - 1 do
  begin
    Add(AArray[I]);
  end;
end;

{ TDictionary<TKey, TValue>.TPairEnumerator }

constructor TDictionary<TKey, TValue>.TPairEnumerator.Create(const ADict: TDictionary<TKey, TValue>);
begin
  { Initialize }
  FDict := ADict;
  KeepObjectAlive(FDict);

  FCurrentIndex := 0;
  FVer := ADict.FVer;
end;

destructor TDictionary<TKey, TValue>.TPairEnumerator.Destroy;
begin
  ReleaseObject(FDict);
  inherited;
end;

function TDictionary<TKey, TValue>.TPairEnumerator.GetCurrent: TPair<TKey,TValue>;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  Result := FValue;
end;

function TDictionary<TKey, TValue>.TPairEnumerator.MoveNext: Boolean;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  while FCurrentIndex < FDict.FCount do
  begin
    if FDict.FEntryArray[FCurrentIndex].FHashCode >= 0 then
    begin
      FValue.Key := FDict.FEntryArray[FCurrentIndex].FKey;
      FValue.Value := FDict.FEntryArray[FCurrentIndex].FValue;

      Inc(FCurrentIndex);
      Result := True;
      Exit;
    end;

    Inc(FCurrentIndex);
  end;

  FCurrentIndex := FDict.FCount + 1;
  Result := False;
end;

{ TDictionary<TKey, TValue>.TKeyEnumerator }

constructor TDictionary<TKey, TValue>.TKeyEnumerator.Create(const ADict: TDictionary<TKey, TValue>);
begin
  { Initialize }
  FDict := ADict;
  KeepObjectAlive(FDict);
  
  FCurrentIndex := 0;
  FVer := ADict.FVer;
  FValue := default(TKey);
end;

destructor TDictionary<TKey, TValue>.TKeyEnumerator.Destroy;
begin
  ReleaseObject(FDict);
  inherited;
end;

function TDictionary<TKey, TValue>.TKeyEnumerator.GetCurrent: TKey;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  Result := FValue;
end;

function TDictionary<TKey, TValue>.TKeyEnumerator.MoveNext: Boolean;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  while FCurrentIndex < FDict.FCount do
  begin
    if FDict.FEntryArray[FCurrentIndex].FHashCode >= 0 then
    begin
      FValue := FDict.FEntryArray[FCurrentIndex].FKey;

      Inc(FCurrentIndex);
      Result := True;
      Exit;
    end;

    Inc(FCurrentIndex);
  end;

  FCurrentIndex := FDict.FCount + 1;
  Result := False;
end;


{ TDictionary<TKey, TValue>.TValueEnumerator }

constructor TDictionary<TKey, TValue>.TValueEnumerator.Create(const ADict: TDictionary<TKey, TValue>);
begin
  { Initialize }
  FDict := ADict;
  KeepObjectAlive(FDict);

  FCurrentIndex := 0;
  FVer := ADict.FVer;
end;

destructor TDictionary<TKey, TValue>.TValueEnumerator.Destroy;
begin
  ReleaseObject(FDict);
  inherited;
end;

function TDictionary<TKey, TValue>.TValueEnumerator.GetCurrent: TValue;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  Result := FValue;
end;

function TDictionary<TKey, TValue>.TValueEnumerator.MoveNext: Boolean;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  while FCurrentIndex < FDict.FCount do
  begin
    if FDict.FEntryArray[FCurrentIndex].FHashCode >= 0 then
    begin
      FValue := FDict.FEntryArray[FCurrentIndex].FValue;

      Inc(FCurrentIndex);
      Result := True;
      Exit;
    end;

    Inc(FCurrentIndex);
  end;

  FCurrentIndex := FDict.FCount + 1;
  Result := False;
end;

{ TDictionary<TKey, TValue>.TKeyCollection }

constructor TDictionary<TKey, TValue>.TKeyCollection.Create(const ADict: TDictionary<TKey, TValue>);
begin
  { Call the upper constructor }
  inherited Create(ADict.KeyRules);

  { Initialize }
  FDict := ADict;
end;

function TDictionary<TKey, TValue>.TKeyCollection.GetCount: NativeInt;
begin
  { Number of elements is the same as key }
  Result := FDict.Count;
end;

function TDictionary<TKey, TValue>.TKeyCollection.GetEnumerator: IEnumerator<TKey>;
begin
  Result := TKeyEnumerator.Create(Self.FDict);
end;

procedure TDictionary<TKey, TValue>.TKeyCollection.CopyTo(var AArray: array of TKey; const AStartIndex: NativeInt);
var
  I, X: NativeInt;
begin
  { Check for indexes }
  if (AStartIndex >= Length(AArray)) or (AStartIndex < 0) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  if (Length(AArray) - AStartIndex) < FDict.Count then
     ExceptionHelper.Throw_ArgumentOutOfSpaceError('AArray');

  X := AStartIndex;

  for I := 0 to FDict.FCount - 1 do
  begin
    if (FDict.FEntryArray[I].FHashCode >= 0) then
    begin
       AArray[X] := FDict.FEntryArray[I].FKey;
       Inc(X);
    end;
  end;
end;

{ TDictionary<TKey, TValue>.TValueCollection }

constructor TDictionary<TKey, TValue>.TValueCollection.Create(const ADict: TDictionary<TKey, TValue>);
begin
  { Call the upper constructor }
  inherited Create(ADict.ValueRules);

  { Initialize }
  FDict := ADict;
end;

function TDictionary<TKey, TValue>.TValueCollection.GetCount: NativeInt;
begin
  { Number of elements is the same as key }
  Result := FDict.Count;
end;

function TDictionary<TKey, TValue>.TValueCollection.GetEnumerator: IEnumerator<TValue>;
begin
  Result := TValueEnumerator.Create(Self.FDict);
end;

procedure TDictionary<TKey, TValue>.TValueCollection.CopyTo(var AArray: array of TValue; const AStartIndex: NativeInt);
var
  I, X: NativeInt;
begin
  if (AStartIndex >= Length(AArray)) or (AStartIndex < 0) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  { Check for indexes }
  if (Length(AArray) - AStartIndex) < FDict.Count then
     ExceptionHelper.Throw_ArgumentOutOfSpaceError('AArray');

  X := AStartIndex;

  for I := 0 to FDict.FCount - 1 do
  begin
    if (FDict.FEntryArray[I].FHashCode >= 0) then
    begin
       AArray[X] := FDict.FEntryArray[I].FValue;
       Inc(X);
    end;
  end;
end;

{ TObjectDictionary<TKey, TValue> }

procedure TObjectDictionary<TKey, TValue>.HandleKeyRemoved(const AKey: TKey);
begin
  if FOwnsKeys then
    TObject(AKey).Free;
end;

procedure TObjectDictionary<TKey, TValue>.HandleValueRemoved(const AValue: TValue);
begin
  if FOwnsValues then
    TObject(AValue).Free;
end;

{ TSortedDictionary<TKey, TValue> }

procedure TSortedDictionary<TKey, TValue>.Add(const APair: TPair<TKey, TValue>);
begin
  { Insert the pair }
  if not Insert(APair.Key, APair.Value, false) then
    ExceptionHelper.Throw_DuplicateKeyError('AKey');
end;

procedure TSortedDictionary<TKey, TValue>.Add(const AKey: TKey; const AValue: TValue);
begin
  { Insert the pair }
  if not Insert(AKey, AValue, false) then
    ExceptionHelper.Throw_DuplicateKeyError('AKey');
end;

procedure TSortedDictionary<TKey, TValue>.BalanceTreesAfterRemoval(const ANode: TNode);
var
  CurrentAct: TBalanceAct;
  LNode, XNode,
    SNode, WNode,
      YNode: TNode;
begin
  { Initiliaze ... }
  CurrentAct := TBalanceAct.baStart;
  LNode := ANode;

  { Continue looping until end is declared }
  while CurrentAct <> TBalanceAct.baEnd do
  begin
    case CurrentAct of

      { START MODE }
      TBalanceAct.baStart:
      begin
        if LNode.FRight = nil then
        begin
          { Exclude myself! }
          if LNode.FLeft <> nil then
            LNode.FLeft.FParent := LNode.FParent;

          { I'm root! nothing to do here }
          if LNode.FParent = nil then
          begin
            FRoot := LNode.FLeft;

            { DONE! }
            CurrentAct := TBalanceAct.baEnd;
            continue;
          end;

          { ... }
          if LNode = LNode.FParent.FLeft then
          begin
            LNode.FParent.FLeft := LNode.FLeft;
            YNode := LNode.FParent;
          end else
          begin
            LNode.FParent.FRight := LNode.FLeft;
            YNode := LNode.FParent;

            { RIGHT! }
            CurrentAct := TBalanceAct.baRight;
            continue;
          end;
        end else if LNode.FRight.FLeft = nil then
        begin
          { Case 1, RIGHT, NO LEFT }
          if LNode.FLeft <> nil then
          begin
            LNode.FLeft.FParent := LNode.FRight;
            LNode.FRight.FLeft := LNode.FLeft;
          end;

          LNode.FRight.FBalance := LNode.FBalance;
          LNode.FRight.FParent := LNode.FParent;

          if LNode.FParent = nil then
            FRoot := LNode.FRight
          else
          begin
            if LNode = LNode.FParent.FLeft then
              LNode.FParent.FLeft := LNode.FRight
            else
              LNode.FParent.FRight := LNode.FRight;
          end;

          YNode := LNode.FRight;

          { RIGHT! }
          CurrentAct := TBalanceAct.baRight;
          continue;
        end else
        begin
          { Case 3: RIGHT+LEFT }
          SNode := LNode.FRight.FLeft;

          while SNode.FLeft <> nil do
            SNode := SNode.FLeft;

          if LNode.FLeft <> nil then
          begin
            LNode.FLeft.FParent := SNode;
            SNode.FLeft := LNode.FLeft;
          end;

          SNode.FParent.FLeft := SNode.FRight;

          if SNode.FRight <> nil then
            SNode.FRight.FParent := SNode.FParent;

          LNode.FRight.FParent := SNode;
          SNode.FRight := LNode.FRight;

          YNode := SNode.FParent;

          SNode.FBalance := LNode.FBalance;
          SNode.FParent := LNode.FParent;

          if LNode.FParent = nil then
            FRoot := SNode
          else
          begin
            if LNode = LNode.FParent.FLeft then
              LNode.FParent.FLeft := SNode
            else
              LNode.FParent.FRight := SNode;
          end;
        end;

        { LEFT! }
        CurrentAct := TBalanceAct.baLeft;
        continue;
      end; { baStart }

      { LEFT BALANCING MODE }
      TBalanceAct.baLeft:
      begin
        Inc(YNode.FBalance);

        if YNode.FBalance = 1 then
        begin
          { DONE! }
          CurrentAct := TBalanceAct.baEnd;
          continue;
        end
        else if YNode.FBalance = 2 then
        begin
          XNode := YNode.FRight;

          if XNode.FBalance = -1 then
          begin
            WNode := XNode.FLeft;
            WNode.FParent := YNode.FParent;

            if YNode.FParent = nil then
              FRoot := WNode
            else
            begin
              if YNode.FParent.FLeft = YNode then
                YNode.FParent.FLeft := WNode
              else
                YNode.FParent.FRight := WNode;
            end;

            XNode.FLeft := WNode.FRight;

            if XNode.FLeft <> nil then
              XNode.FLeft.FParent := XNode;

            YNode.FRight := WNode.FLeft;

            if YNode.FRight <> nil then
              YNode.FRight.FParent := YNode;

            WNode.FRight := XNode;
            WNode.FLeft := YNode;

            XNode.FParent := WNode;
            YNode.FParent := WNode;

            if WNode.FBalance = 1 then
            begin
              XNode.FBalance := 0;
              YNode.FBalance := -1;
            end else if WNode.FBalance = 0 then
            begin
              XNode.FBalance := 0;
              YNode.FBalance := 0;
            end else
            begin
              XNode.FBalance := 1;
              YNode.FBalance := 0;
            end;

            WNode.FBalance := 0;
            YNode := WNode;
          end else
          begin
            XNode.FParent := YNode.FParent;

            if YNode.FParent <> nil then
            begin
              if YNode.FParent.FLeft = YNode then
                YNode.FParent.FLeft := XNode
              else
                YNode.FParent.FRight := XNode;
            end else
              FRoot := XNode;

            YNode.FRight := XNode.FLeft;

            if YNode.FRight <> nil then
              YNode.FRight.FParent := YNode;

            XNode.FLeft := YNode;
            YNode.FParent := XNode;

            if XNode.FBalance = 0 then
            begin
              XNode.FBalance := -1;
              YNode.FBalance := 1;

              { DONE! }
              CurrentAct := TBalanceAct.baEnd;
              continue;
            end else
            begin
              XNode.FBalance := 0;
              YNode.FBalance := 0;

              YNode := XNode;
            end;
          end;
        end;

        { LOOP! }
        CurrentAct := TBalanceAct.baLoop;
        continue;
      end; { baLeft }

      { RIGHT BALANCING MODE }
      TBalanceAct.baRight:
      begin
        Dec(YNode.FBalance);

        if YNode.FBalance = -1 then
        begin
          { DONE! }
          CurrentAct := TBalanceAct.baEnd;
          continue;
        end
        else if YNode.FBalance = -2 then
        begin
          XNode := YNode.FLeft;

          if XNode.FBalance = 1 then
          begin
            WNode := XNode.FRight;
            WNode.FParent := YNode.FParent;

            if YNode.FParent = nil then
              FRoot := WNode
            else
            begin
              if YNode.FParent.FLeft = YNode then
                YNode.FParent.FLeft := WNode
              else
                YNode.FParent.FRight := WNode;
            end;

            XNode.FRight := WNode.FLeft;

            if XNode.FRight <> nil then
              XNode.FRight.FParent := XNode;

            YNode.FLeft := WNode.FRight;

            if YNode.FLeft <> nil then
              YNode.FLeft.FParent := YNode;

            WNode.FLeft := XNode;
            WNode.FRight := YNode;

            XNode.FParent := WNode;
            YNode.FParent := WNode;

            if WNode.FBalance = -1 then
            begin
              XNode.FBalance := 0;
              YNode.FBalance := 1;
            end else if WNode.FBalance = 0 then
            begin
              XNode.FBalance := 0;
              YNode.FBalance := 0;
            end else
            begin
              XNode.FBalance := -1;
              YNode.FBalance := 0;
            end;

            WNode.FBalance := 0;
            YNode := WNode;
          end else
          begin
            XNode.FParent := YNode.FParent;

            if YNode.FParent <> nil then
            begin
              if YNode.FParent.FLeft = YNode then
                YNode.FParent.FLeft := XNode
              else
                YNode.FParent.FRight := XNode
            end else
              FRoot := XNode;

            YNode.FLeft := XNode.FRight;

            if YNode.FLeft <> nil then
              YNode.FLeft.FParent := YNode;

            XNode.FRight := YNode;
            YNode.FParent := XNode;

            if XNode.FBalance = 0 then
            begin
              XNode.FBalance := 1;
              YNode.FBalance := -1;

              { END! }
              CurrentAct := TBalanceAct.baEnd;
              continue;
            end else
            begin
              XNode.FBalance := 0;
              YNode.FBalance := 0;

              YNode := XNode;
            end;
          end;
        end;

        { LOOP! }
        CurrentAct := TBalanceAct.baLoop;
        continue;
      end; { baRight }

      TBalanceAct.baLoop:
      begin
        { Verify continuation }
        if YNode.FParent <> nil then
        begin
          if YNode = YNode.FParent.FLeft then
          begin
            YNode := YNode.FParent;

            { LEFT! }
            CurrentAct := TBalanceAct.baLeft;
            continue;
          end;

          YNode := YNode.FParent;

          { RIGHT! }
          CurrentAct := TBalanceAct.baRight;
          continue;
        end;

        { END! }
        CurrentAct := TBalanceAct.baEnd;
        continue;
      end;
    end; { Case }
  end; { While }
end;

procedure TSortedDictionary<TKey, TValue>.Clear;
begin
  if FRoot <> nil then
  begin
    RecursiveClear(FRoot);
    FRoot := nil;

    { Update markers }
    Inc(FVer);
    FCount := 0;
  end;
end;

function TSortedDictionary<TKey, TValue>.ContainsKey(const AKey: TKey): Boolean;
begin
  Result := FindNodeWithKey(AKey) <> nil;
end;

function TSortedDictionary<TKey, TValue>.ContainsValue(const AValue: TValue): Boolean;
var
  LNode: TNode;
begin
  { Find the left-most node }
  LNode := FindLeftMostNode();

  while (LNode <> nil) do
  begin
    { Verify existance }
    if ValueRules.AreEqual(LNode.FValue, AValue) then
      Exit(true);

    { Navigate further in the tree }
    LNode := WalkToTheRight(LNode);
  end;

  Exit(false);
end;

procedure TSortedDictionary<TKey, TValue>.CopyTo(var AArray: array of TPair<TKey, TValue>; const AStartIndex: NativeInt);
var
  X: NativeInt;
  LNode: TNode;
begin
  { Check for indexes }
  if (AStartIndex >= Length(AArray)) or (AStartIndex < 0) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  if (Length(AArray) - AStartIndex) < FCount then
     ExceptionHelper.Throw_ArgumentOutOfSpaceError('AArray');

  X := AStartIndex;

  { Find the left-most node }
  LNode := FindLeftMostNode();

  while (LNode <> nil) do
  begin
    { Get the key }
    AArray[X].Key := LNode.FKey;
    AArray[X].Value := LNode.FValue;

    { Navigate further in the tree }
    LNode := WalkToTheRight(LNode);

    { Increment the index }
    Inc(X);
  end;
end;

constructor TSortedDictionary<TKey, TValue>.Create(const AAscending: Boolean);
begin
  Create(TRules<TKey>.Default, TRules<TValue>.Default, AAscending);
end;

constructor TSortedDictionary<TKey, TValue>.Create(const ACollection: IEnumerable<TPair<TKey, TValue>>;
  const AAscending: Boolean);
begin
  Create(TRules<TKey>.Default, TRules<TValue>.Default, ACollection, AAscending);
end;

constructor TSortedDictionary<TKey, TValue>.Create(const AKeyRules: TRules<TKey>; const AValueRules: TRules<TValue>;
  const ACollection: IEnumerable<TPair<TKey, TValue>>; const AAscending: Boolean);
var
  V: TPair<TKey, TValue>;
begin
  { Call upper constructor }
  Create(AKeyRules, AValueRules, AAscending);

  if (ACollection = nil) then
     ExceptionHelper.Throw_ArgumentNilError('ACollection');

  { Pump in all items }
  for V in ACollection do
  begin
{$IFNDEF BUG_GENERIC_INCOMPAT_TYPES}
    Add(V);
{$ELSE}
    Add(V.Key, V.Value);
{$ENDIF}
  end;
end;

constructor TSortedDictionary<TKey, TValue>.Create(const AKeyRules: TRules<TKey>;
  const AValueRules: TRules<TValue>; const AAscending: Boolean);
begin
  { Call the upper constructor }
  inherited Create(AKeyRules, AValueRules);

  FKeyCollection := TKeyCollection.Create(Self);
  FValueCollection := TValueCollection.Create(Self);

  FVer := 0;
  FCount := 0;

  if AAscending then
    FSignFix := 1
  else
    FSignFix := -1;
end;

destructor TSortedDictionary<TKey, TValue>.Destroy;
begin
  { Clear first }
  Clear();

  inherited;
end;

function TSortedDictionary<TKey, TValue>.FindLeftMostNode: TNode;
begin
  { Start with root }
  Result := FRoot;

  { And go to maximum left }
  if Result <> nil then
  begin
    while Result.FLeft <> nil do
      Result := Result.FLeft;
  end;
end;

function TSortedDictionary<TKey, TValue>.FindNodeWithKey(const AKey: TKey): TNode;
var
  LNode: TNode;
  Compare: NativeInt;
  HACK: IInterface;
begin
  { Get root }
  LNode := FRoot;

  while LNode <> nil do
  begin
	  Compare := KeyRules.Compare(AKey, LNode.FKey) * FSignFix;

    { Navigate left, right or find! }
    if Compare < 0 then
      LNode := LNode.FLeft
    else if Compare > 0 then
      LNode := LNode.FRight
    else
      Exit(LNode);
  end;

  { Did not find anything ... }
  Result := nil;
end;

function TSortedDictionary<TKey, TValue>.FindRightMostNode: TNode;
begin
  { Start with root }
  Result := FRoot;

  { And go to maximum left }
  if Result <> nil then
  begin
    while Result.FRight <> nil do
      Result := Result.FRight;
  end;
end;

function TSortedDictionary<TKey, TValue>.GetCount: NativeInt;
begin
  Result := FCount;
end;

function TSortedDictionary<TKey, TValue>.GetEnumerator: IEnumerator<TPair<TKey, TValue>>;
begin
  Result := TPairEnumerator.Create(Self);
end;

function TSortedDictionary<TKey, TValue>.GetItem(const AKey: TKey): TValue;
begin
  if not TryGetValue(AKey, Result) then
    ExceptionHelper.Throw_KeyNotFoundError('AKey');
end;

function TSortedDictionary<TKey, TValue>.Insert(const AKey: TKey; const AValue: TValue; const ChangeOrFail: Boolean): Boolean;
var
  LNode: TNode;
  Compare: NativeInt;
begin
  { First one get special treatment! }
  if FRoot = nil then
  begin
    FRoot := MakeNode(AKey, AValue, nil);

    { Increase markers }
    Inc(FCount);
    Inc(FVer);

    { [ADDED NEW] Exit function }
    Exit(true);
  end;

  { Get root }
  LNode := FRoot;

  while true do
  begin
	  Compare := KeyRules.Compare(AKey, LNode.FKey) * FSignFix;

    if Compare < 0 then
    begin
      if LNode.FLeft <> nil then
        LNode := LNode.FLeft
      else
      begin
        { Create  new node }
        LNode.FLeft := MakeNode(AKey, AValue, LNode);
        Dec(LNode.FBalance);

        { [ADDED NEW] Exit function! }
        break;
      end;
    end else if Compare > 0 then
    begin
      if LNode.FRight <> nil then
        LNode := LNode.FRight
      else
      begin
        LNode.FRight := MakeNode(AKey, AValue, LNode);
        Inc(LNode.FBalance);

        { [ADDED NEW] Exit function! }
        break;
      end;
    end else
    begin
      { Found  node with the same AKey. Check what to do next }
      if not ChangeOrFail then
        Exit(false);

      { Cleanup the value if required }
      NotifyValueRemoved(LNode.FValue);

      { Change the node value }
      LNode.FValue := AValue;

      { Increase markers }
      Inc(FVer);

      { [CHANGED OLD] Exit function }
      Exit(true);
    end;
  end;

  { Rebalance the tree }
  ReBalanceSubTreeOnInsert(LNode);

  Inc(FCount);
  Inc(FVer);

  Result := true;
end;

function TSortedDictionary<TKey, TValue>.KeyHasValue(const AKey: TKey; const AValue: TValue): Boolean;
var
  LValue: TValue;
begin
  Result := TryGetValue(AKey, LValue) and ValueRules.AreEqual(LValue, AValue);
end;

function TSortedDictionary<TKey, TValue>.MakeNode(const AKey: TKey; const AValue: TValue; const ARoot: TNode): TNode;
begin
  Result := TNode.Create();
  Result.FKey := AKey;
  Result.FValue := AValue;
  Result.FParent := ARoot;
end;

function TSortedDictionary<TKey, TValue>.MaxKey: TKey;
begin
  { Check there are elements in the set }
  if FRoot = nil then
    ExceptionHelper.Throw_CollectionEmptyError();

  if FSignFix = 1 then
    Result := FindRightMostNode().FKey
  else
    Result := FindLeftMostNode().FKey;
end;

function TSortedDictionary<TKey, TValue>.MinKey: TKey;
begin
  { Check there are elements in the set }
  if FRoot = nil then
    ExceptionHelper.Throw_CollectionEmptyError();

  if FSignFix = 1 then
    Result := FindLeftMostNode().FKey
  else
    Result := FindRightMostNode().FKey;
end;

procedure TSortedDictionary<TKey, TValue>.ReBalanceSubTreeOnInsert(const ANode: TNode);
var
  LNode, XNode, WNode: TNode;
  Compare: NativeInt;
begin
  (*
    DISCLAIMER: I HAVE LITTLE TO ABSOLUTELY NO IDEA HOW THIS SPAGETTI WORKS!
    DO NOT BLAME ME :D (Alex).
  *)

  LNode := ANode;

  { Re-balancing the tree! }
  while ((LNode.FBalance <> 0) and (LNode.FParent <> nil)) do
  begin
    if (LNode.FParent.FLeft = LNode) then
      Dec(LNode.FParent.FBalance)
    else
      Inc(LNode.FParent.FBalance);

    { Move up }
    LNode := LNode.FParent;

    if (LNode.FBalance = -2) then
    begin
      XNode := LNode.FLeft;

      if (XNode.FBalance = -1) then
      begin
        XNode.FParent := LNode.FParent;

        if (LNode.FParent = nil) then
          FRoot := XNode
        else
        begin
          if (LNode.FParent.FLeft = LNode) then
            LNode.FParent.FLeft := XNode
          else
            LNode.FParent.FRight := XNode;
        end;

        LNode.FLeft := XNode.FRight;

        if LNode.FLeft <> nil then
          LNode.FLeft.FParent := LNode;

        XNode.FRight := LNode;
        LNode.FParent := XNode;

        XNode.FBalance := 0;
        LNode.FBalance := 0;
      end else
      begin
        WNode := XNode.FRight;
        WNode.FParent := LNode.FParent;

        if LNode.FParent = nil then
          FRoot := WNode
        else
        begin
          if LNode.FParent.FLeft = LNode then
            LNode.FParent.FLeft := WNode
          else
            LNode.FParent.FRight := WNode;
        end;

        XNode.FRight := WNode.FLeft;

        if XNode.FRight <> nil then
          XNode.FRight.FParent := XNode;

        LNode.FLeft := WNode.FRight;

        if LNode.FLeft <> nil then
          LNode.FLeft.FParent := LNode;

        WNode.FLeft := XNode;
        WNode.FRight := LNode;

        XNode.FParent := WNode;
        LNode.FParent := WNode;

        { Apply proper balancing }
        if WNode.FBalance = -1 then
        begin
          XNode.FBalance := 0;
          LNode.FBalance := 1;
        end else if WNode.FBalance = 0 then
        begin
          XNode.FBalance := 0;
          LNode.FBalance := 0;
        end else
        begin
          XNode.FBalance := -1;
          LNode.FBalance := 0;
        end;

        WNode.FBalance := 0;
      end;

      break;
    end else if LNode.FBalance = 2 then
    begin
      XNode := LNode.FRight;

      if XNode.FBalance = 1 then
      begin
        XNode.FParent := LNode.FParent;

        if LNode.FParent = nil then
          FRoot := XNode
        else
        begin
          if LNode.FParent.FLeft = LNode then
            LNode.FParent.FLeft := XNode
          else
            LNode.FParent.FRight := XNode;
        end;

        LNode.FRight := XNode.FLeft;

        if LNode.FRight <> nil then
          LNode.FRight.FParent := LNode;

        XNode.FLeft := LNode;
        LNode.FParent := XNode;

        XNode.FBalance := 0;
        LNode.FBalance := 0;
      end else
      begin
        WNode := XNode.FLeft;
        WNode.FParent := LNode.FParent;

        if LNode.FParent = nil then
          FRoot := WNode
        else
        begin
          if LNode.FParent.FLeft = LNode then
            LNode.FParent.FLeft := WNode
          else
            LNode.FParent.FRight := WNode;
        end;

        XNode.FLeft := WNode.FRight;

        if XNode.FLeft <> nil then
          XNode.FLeft.FParent := XNode;

        LNode.FRight := WNode.FLeft;

        if LNode.FRight <> nil then
          LNode.FRight.FParent := LNode;

        WNode.FRight := XNode;
        WNode.FLeft := LNode;

        XNode.FParent := WNode;
        LNode.FParent := WNode;

        if WNode.FBalance = 1 then
        begin
          XNode.FBalance := 0;
          LNode.FBalance := -1;
        end else if WNode.FBalance = 0 then
        begin
          XNode.FBalance := 0;
          LNode.FBalance := 0;
        end else
        begin
          XNode.FBalance := 1;
          LNode.FBalance := 0;
        end;

        WNode.FBalance := 0;
      end;

      break;
    end;
  end;

end;

procedure TSortedDictionary<TKey, TValue>.Remove(const AKey: TKey);
var
  LNode: TNode;

begin
  { Get root }
  LNode := FindNodeWithKey(AKey);

  { Remove and rebalance the tree accordingly }
  if LNode = nil then
    Exit;

  { .. Do da dew! }
  BalanceTreesAfterRemoval(LNode);

  { Kill the stored value }
  NotifyValueRemoved(LNode.FValue);

  { Kill the node }
  LNode.Free;

  Dec(FCount);
  Inc(FVer);
end;

procedure TSortedDictionary<TKey, TValue>.RecursiveClear(const ANode: TNode);
begin
  if ANode.FLeft <> nil then
    RecursiveClear(ANode.FLeft);

  if ANode.FRight <> nil then
    RecursiveClear(ANode.FRight);

  { Cleanup for AKey/Value }
  NotifyKeyRemoved(ANode.FKey);
  NotifyValueRemoved(ANode.FValue);

  { Finally, free the node itself }
  ANode.Free;
end;

function TSortedDictionary<TKey, TValue>.SelectKeys: IEnexCollection<TKey>;
begin
  Result := Keys;
end;

function TSortedDictionary<TKey, TValue>.SelectValues: IEnexCollection<TValue>;
begin
  Result := Values;
end;

procedure TSortedDictionary<TKey, TValue>.SetItem(const AKey: TKey; const Value: TValue);
begin
  { Allow inserting and adding values }
  Insert(AKey, Value, true);
end;

function TSortedDictionary<TKey, TValue>.TryGetValue(const AKey: TKey; out AFoundValue: TValue): Boolean;
var
  ResultNode: TNode;
begin
  ResultNode := FindNodeWithKey(AKey);

  if ResultNode <> nil then
  begin
    AFoundValue := ResultNode.FValue;
    Exit(true);
  end;

  { Default }
  AFoundValue := default(TValue);
  Exit(false);
end;

function TSortedDictionary<TKey, TValue>.ValueForKey(const AKey: TKey): TValue;
begin
  Result := GetItem(AKey);
end;

function TSortedDictionary<TKey, TValue>.WalkToTheRight(const ANode: TNode): TNode;
begin
  Result := ANode;

  if Result = nil then
    Exit;

  { Navigate further in the tree }
  if Result.FRight = nil then
  begin
    while ((Result.FParent <> nil) and (Result = Result.FParent.FRight)) do
      Result := Result.FParent;

    Result := Result.FParent;
  end else
  begin
    Result := Result.FRight;

    while Result.FLeft <> nil do
      Result := Result.FLeft;
  end;
end;

constructor TSortedDictionary<TKey, TValue>.Create(const AArray: array of TPair<TKey, TValue>;
  const AAscending: Boolean);
begin
  Create(TRules<TKey>.Default, TRules<TValue>.Default, AArray, AAscending);
end;

constructor TSortedDictionary<TKey, TValue>.Create(
  const AKeyRules: TRules<TKey>;
  const AValueRules: TRules<TValue>;
  const AArray: array of TPair<TKey, TValue>;
  const AAscending: Boolean);
var
  I: NativeInt;
begin
  { Call upper constructor }
  Create(AKeyRules, AValueRules, AAscending);

  { Copy all items in }
  for I := 0 to Length(AArray) - 1 do
  begin
    Add(AArray[I]);
  end;
end;

{ TSortedDictionary<TKey, TValue>.TPairEnumerator }

constructor TSortedDictionary<TKey, TValue>.TPairEnumerator.Create(const ADict: TSortedDictionary<TKey, TValue>);
begin
  { Initialize }
  FDict := ADict;
  KeepObjectAlive(FDict);

  FNext := ADict.FindLeftMostNode();
  FVer := ADict.FVer;
end;

destructor TSortedDictionary<TKey, TValue>.TPairEnumerator.Destroy;
begin
  ReleaseObject(FDict);
  inherited;
end;

function TSortedDictionary<TKey, TValue>.TPairEnumerator.GetCurrent: TPair<TKey,TValue>;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  Result := FValue;
end;

function TSortedDictionary<TKey, TValue>.TPairEnumerator.MoveNext: Boolean;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  { Do not continue on last node }
  if FNext = nil then
    Exit(false);

  { Get the current value }
  FValue.Key := FNext.FKey;
  FValue.Value := FNext.FValue;

  { Navigate further in the tree }
  FNext := FDict.WalkToTheRight(FNext);

  Result := true;
end;

{ TSortedDictionary<TKey, TValue>.TKeyEnumerator }

constructor TSortedDictionary<TKey, TValue>.TKeyEnumerator.Create(const ADict: TSortedDictionary<TKey, TValue>);
begin
  { Initialize }
  FDict := ADict;
  KeepObjectAlive(FDict);

  FNext := ADict.FindLeftMostNode();

  FVer := ADict.FVer;
end;

destructor TSortedDictionary<TKey, TValue>.TKeyEnumerator.Destroy;
begin
  ReleaseObject(FDict);
  inherited;
end;

function TSortedDictionary<TKey, TValue>.TKeyEnumerator.GetCurrent: TKey;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  Result := FValue;
end;

function TSortedDictionary<TKey, TValue>.TKeyEnumerator.MoveNext: Boolean;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  { Do not continue on last node }
  if FNext = nil then
    Exit(false);

  { Get the current value }
  FValue := FNext.FKey;

  { Navigate further in the tree }
  FNext := FDict.WalkToTheRight(FNext);

  Result := true;
end;


{ TSortedDictionary<TKey, TValue>.TValueEnumerator }

constructor TSortedDictionary<TKey, TValue>.TValueEnumerator.Create(const ADict: TSortedDictionary<TKey, TValue>);
begin
  { Initialize }
  FDict := ADict;
  KeepObjectAlive(FDict);

  FNext := ADict.FindLeftMostNode();

  FVer := ADict.FVer;
end;

destructor TSortedDictionary<TKey, TValue>.TValueEnumerator.Destroy;
begin
  ReleaseObject(FDict);
  inherited;
end;

function TSortedDictionary<TKey, TValue>.TValueEnumerator.GetCurrent: TValue;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  Result := FValue;
end;

function TSortedDictionary<TKey, TValue>.TValueEnumerator.MoveNext: Boolean;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  { Do not continue on last node }
  if FNext = nil then
    Exit(false);

  { Get the current value }
  FValue := FNext.FValue;

  { Navigate further in the tree }
  FNext := FDict.WalkToTheRight(FNext);

  Result := true;
end;

{ TSortedDictionary<TKey, TValue>.TKeyCollection }

constructor TSortedDictionary<TKey, TValue>.TKeyCollection.Create(const ADict: TSortedDictionary<TKey, TValue>);
begin
  { Call the upper constructor }
  inherited Create(ADict.KeyRules);

  { Initialize }
  FDict := ADict;
end;

function TSortedDictionary<TKey, TValue>.TKeyCollection.GetCount: NativeInt;
begin
  { Number of elements is the same as AKey }
  Result := FDict.Count;
end;

function TSortedDictionary<TKey, TValue>.TKeyCollection.GetEnumerator: IEnumerator<TKey>;
begin
  Result := TKeyEnumerator.Create(Self.FDict);
end;

procedure TSortedDictionary<TKey, TValue>.TKeyCollection.CopyTo(var AArray: array of TKey; const AStartIndex: NativeInt);
var
  I, X: NativeInt;
  LNode: TNode;
begin
  { Check for indexes }
  if (AStartIndex >= Length(AArray)) or (AStartIndex < 0) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  if (Length(AArray) - AStartIndex) < FDict.Count then
     ExceptionHelper.Throw_ArgumentOutOfSpaceError('AArray');

  X := AStartIndex;

  { Find the left-most node }
  LNode := FDict.FindLeftMostNode();

  while (LNode <> nil) do
  begin
    { Get the AKey }
    AArray[X] := LNode.FKey;

    { Navigate further in the tree }
    LNode := FDict.WalkToTheRight(LNode);

    { Increment the index }
    Inc(X);
  end;
end;

{ TSortedDictionary<TKey, TValue>.TValueCollection }

constructor TSortedDictionary<TKey, TValue>.TValueCollection.Create(const ADict: TSortedDictionary<TKey, TValue>);
begin
  { Call the upper constructor }
  inherited Create(ADict.ValueRules);

  { Initialize }
  FDict := ADict;
end;

function TSortedDictionary<TKey, TValue>.TValueCollection.GetCount: NativeInt;
begin
  { Number of elements is the same as AKey }
  Result := FDict.Count;
end;

function TSortedDictionary<TKey, TValue>.TValueCollection.GetEnumerator: IEnumerator<TValue>;
begin
  Result := TValueEnumerator.Create(Self.FDict);
end;

procedure TSortedDictionary<TKey, TValue>.TValueCollection.CopyTo(var AArray: array of TValue; const AStartIndex: NativeInt);
var
  X: NativeInt;
  LNode: TNode;
begin
  { Check for indexes }
  if (AStartIndex >= Length(AArray)) or (AStartIndex < 0) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  if (Length(AArray) - AStartIndex) < FDict.Count then
     ExceptionHelper.Throw_ArgumentOutOfSpaceError('AArray');

  X := AStartIndex;

  { Find the left-most node }
  LNode := FDict.FindLeftMostNode();

  while (LNode <> nil) do
  begin
    { Get the AKey }
    AArray[X] := LNode.FValue;

    { Navigate further in the tree }
    LNode := FDict.WalkToTheRight(LNode);

    { Increment the index }
    Inc(X);
  end;
end;

{ TObjectSortedDictionary<TKey, TValue> }

procedure TObjectSortedDictionary<TKey, TValue>.HandleKeyRemoved(const AKey: TKey);
begin
  if FOwnsKeys then
    TObject(AKey).Free;
end;

procedure TObjectSortedDictionary<TKey, TValue>.HandleValueRemoved(const AValue: TValue);
begin
  if FOwnsValues then
    TObject(AValue).Free;
end;

end.
