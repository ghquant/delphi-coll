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

unit Collections.Sets;
interface
uses SysUtils,
     Collections.Base;

type
  ///  <summary>The generic <c>set</c> collection.</summary>
  ///  <remarks>This type uses hashing techniques to store its values.</remarks>
  THashSet<T> = class(TEnexCollection<T>, ISet<T>)
  private type
    {$REGION 'Internal Types'}
    TEnumerator = class(TEnumerator<T>)
    private
      FVer: NativeInt;
      FDict: THashSet<T>;
      FCurrentIndex: NativeInt;
      FValue: T;

    public
      { Constructor }
      constructor Create(const ADict: THashSet<T>);

      { Destructor }
      destructor Destroy(); override;

      function GetCurrent(): T; override;
      function MoveNext(): Boolean; override;
    end;

    TEntry = record
      FHashCode: NativeInt;
      FNext: NativeInt;
      FKey: T;
    end;

    TBucketArray = array of NativeInt;
    {$ENDREGION}

  private var
    FBucketArray: TBucketArray;
    FEntryArray: TArray<TEntry>;
    FCount: NativeInt;
    FFreeCount: NativeInt;
    FFreeList: NativeInt;
    FVer: NativeInt;

    { Internal }
    procedure InitializeInternals(const ACapacity: NativeInt);
    procedure Insert(const AKey: T; const ShouldAdd: Boolean = true);
    function FindEntry(const AKey: T): NativeInt;
    procedure Resize();
    function Hash(const AKey: T): NativeInt;

  protected
    ///  <summary>Returns the number of elements in the set.</summary>
    ///  <returns>A positive value specifying the number of elements in the set.</returns>
    function GetCount(): NativeInt; override;
  public
    ///  <summary>Creates a new instance of this class.</summary>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AInitialCapacity">The set's initial capacity.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AInitialCapacity: NativeInt); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ACollection">A collection to copy elements from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const ACollection: IEnumerable<T>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy elements from.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AArray: array of T); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AInitialCapacity">The set's initial capacity.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>; const AInitialCapacity: NativeInt); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ACollection">A collection to copy elements from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>; const ACollection: IEnumerable<T>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy elements from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>; const AArray: array of T); overload;

    ///  <summary>Destroys this instance.</summary>
    ///  <remarks>Do not call this method directly, call <c>Free</c> instead</remarks>
    destructor Destroy(); override;

    ///  <summary>Clears the contents of the set.</summary>
    ///  <remarks>This method clears the set and invokes type object's cleaning routines for each element.</remarks>
    procedure Clear();

    ///  <summary>Adds an element to the set.</summary>
    ///  <param name="AValue">The value to add.</param>
    ///  <remarks>If the set already contains the given value, nothing happens.</remarks>
    procedure Add(const AValue: T);

    ///  <summary>Removes a given value from the set.</summary>
    ///  <param name="AValue">The value to remove.</param>
    ///  <remarks>If the set does not contain the given value, nothing happens.</remarks>
    procedure Remove(const AValue: T);

    ///  <summary>Checks whether the set contains a given value.</summary>
    ///  <param name="AValue">The value to check.</param>
    ///  <returns><c>True</c> if the value was found in the set; <c>False</c> otherwise.</returns>
    function Contains(const AValue: T): Boolean;

    ///  <summary>Specifies the number of elements in the set.</summary>
    ///  <returns>A positive value specifying the number of elements in the set.</returns>
    property Count: NativeInt read GetCount;

    ///  <summary>Returns a new enumerator object used to enumerate this set.</summary>
    ///  <remarks>This method is usually called by compiler generated code. Its purpose is to create an enumerator
    ///  object that is used to actually traverse the set.</remarks>
    ///  <returns>An enumerator object.</returns>
    function GetEnumerator() : IEnumerator<T>; override;

    ///  <summary>Copies the values stored in the set to a given array.</summary>
    ///  <param name="AArray">An array where to copy the contents of the set.</param>
    ///  <param name="AStartIndex">The index into the array at which the copying begins.</param>
    ///  <remarks>This method assumes that <paramref name="AArray"/> has enough space to hold the contents of the set.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AStartIndex"/> is out of bounds.</exception>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfSpaceException">There array is not long enough.</exception>
    procedure CopyTo(var AArray: array of T; const AStartIndex: NativeInt); overload; override;

    ///  <summary>Checks whether the set is empty.</summary>
    ///  <returns><c>True</c> if the set is empty; <c>False</c> otherwise.</returns>
    ///  <remarks>This method is the recommended way of detecting if the set is empty.</remarks>
    function Empty(): Boolean; override;
  end;

  ///  <summary>The generic <c>set</c> collection designed to store objects.</summary>
  ///  <remarks>This type uses hashing techniques to store its objects.</remarks>
  TObjectHashSet<T: class> = class(THashSet<T>)
  private
    FOwnsObjects: Boolean;

  protected
    ///  <summary>Frees the object that was removed from the collection.</summary>
    ///  <param name="AElement">The object that was removed from the collection.</param>
    procedure HandleElementRemoved(const AElement: T); override;
  public
    ///  <summary>Specifies whether this set owns the objects stored in it.</summary>
    ///  <returns><c>True</c> if the set owns its objects; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the set controls the life-time of the stored objects.</remarks>
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
  end;

type
  ///  <summary>The generic <c>set</c> collection.</summary>
  ///  <remarks>This type uses an AVL tree to store its values.</remarks>
  TSortedSet<T> = class(TEnexCollection<T>, ISet<T>)
  private type
    {$REGION 'Internal Types'}
    TBalanceAct = (baStart, baLeft, baRight, baLoop, baEnd);

    { An internal node class }
    TNode = class
    private
      FKey: T;

      FParent,
       FLeft, FRight: TNode;

      FBalance: ShortInt;
    end;

    TEnumerator = class(TEnumerator<T>)
    private
      FVer: NativeInt;
      FDict: TSortedSet<T>;
      FNext: TNode;
      FValue: T;

    public
      { Constructor }
      constructor Create(const ADict: TSortedSet<T>);

      { Destructor }
      destructor Destroy(); override;

      function GetCurrent(): T; override;
      function MoveNext(): Boolean; override;
    end;
    {$ENDREGION}

  private var
    FCount: NativeInt;
    FVer: NativeInt;
    FRoot: TNode;
    FSignFix: NativeInt;

    { Some internals }
    function FindNodeWithKey(const AValue: T): TNode;
    function FindLeftMostNode(): TNode;
    function FindRightMostNode(): TNode;
    function WalkToTheRight(const ANode: TNode): TNode;

    { ... }
    function MakeNode(const AValue: T; const ARoot: TNode): TNode;
    procedure RecursiveClear(const ANode: TNode);
    procedure ReBalanceSubTreeOnInsert(const ANode: TNode);
    procedure Insert(const AValue: T);

    { Removal }
    procedure BalanceTreesAfterRemoval(const ANode: TNode);
  protected
    ///  <summary>Returns the number of elements in the set.</summary>
    ///  <returns>A positive value specifying the number of elements in the set.</returns>
    function GetCount(): NativeInt; override;
  public
    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AAscending">Specifies whether the elements are kept sorted in ascending order. Default is <c>True</c>.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ACollection">A collection to copy elements from.</param>
    ///  <param name="AAscending">Specifies whether the elements are kept sorted in ascending order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const ACollection: IEnumerable<T>; const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy elements from.</param>
    ///  <param name="AAscending">Specifies whether the elements are kept sorted in ascending order. Default is <c>True</c>.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AArray: array of T; const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ARules">A type object decribing the elements in the set.</param>
    ///  <param name="AAscending">Specifies whether the elements are kept sorted in ascending order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>; const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ARules">A type object decribing the elements in the set.</param>
    ///  <param name="ACollection">A collection to copy elements from.</param>
    ///  <param name="AAscending">Specifies whether the elements are kept sorted in ascending order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>; const ACollection: IEnumerable<T>; const AAscending: Boolean = true); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ARules">A type object decribing the elements in the set.</param>
    ///  <param name="AArray">An array to copy elements from.</param>
    ///  <param name="AAscending">Specifies whether the elements are kept sorted in ascending order. Default is <c>True</c>.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>; const AArray: array of T; const AAscending: Boolean = true); overload;

    ///  <summary>Destroys this instance.</summary>
    ///  <remarks>Do not call this method directly, call <c>Free</c> instead</remarks>
    destructor Destroy(); override;

    ///  <summary>Clears the contents of the set.</summary>
    ///  <remarks>This method clears the set and invokes type object's cleaning routines for each element.</remarks>
    procedure Clear();

    ///  <summary>Adds an element to the set.</summary>
    ///  <param name="AValue">The value to add.</param>
    ///  <remarks>If the set already contains the given value, nothing happens.</remarks>
    procedure Add(const AValue: T);

    ///  <summary>Removes a given value from the set.</summary>
    ///  <param name="AValue">The value to remove.</param>
    ///  <remarks>If the set does not contain the given value, nothing happens.</remarks>
    procedure Remove(const AValue: T);

    ///  <summary>Checks whether the set contains a given value.</summary>
    ///  <param name="AValue">The value to check.</param>
    ///  <returns><c>True</c> if the value was found in the set; <c>False</c> otherwise.</returns>
    function Contains(const AValue: T): Boolean;

    ///  <summary>Specifies the number of elements in the set.</summary>
    ///  <returns>A positive value specifying the number of elements in the set.</returns>
    property Count: NativeInt read FCount;

    ///  <summary>Returns a new enumerator object used to enumerate this set.</summary>
    ///  <remarks>This method is usually called by compiler generated code. Its purpose is to create an enumerator
    ///  object that is used to actually traverse the set.</remarks>
    ///  <returns>An enumerator object.</returns>
    function GetEnumerator() : IEnumerator<T>; override;

    ///  <summary>Copies the values stored in the set to a given array.</summary>
    ///  <param name="AArray">An array where to copy the contents of the set.</param>
    ///  <param name="AStartIndex">The index into the array at which the copying begins.</param>
    ///  <remarks>This method assumes that <paramref name="AArray"/> has enough space to hold the contents of the set.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AStartIndex"/> is out of bounds.</exception>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfSpaceException">There array is not long enough.</exception>
    procedure CopyTo(var AArray: array of T; const AStartIndex: NativeInt); overload; override;

    ///  <summary>Checks whether the set is empty.</summary>
    ///  <returns><c>True</c> if the set is empty; <c>False</c> otherwise.</returns>
    ///  <remarks>This method is the recommended way of detecting if the set is empty.</remarks>
    function Empty(): Boolean; override;

    ///  <summary>Returns the biggest element.</summary>
    ///  <returns>An element from the set considered to have the biggest value.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The set is empty.</exception>
    function Max(): T; override;

    ///  <summary>Returns the smallest element.</summary>
    ///  <returns>An element from the set considered to have the smallest value.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The set is empty.</exception>
    function Min(): T; override;

    ///  <summary>Returns the first element.</summary>
    ///  <returns>The first element in the set.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The set is empty.</exception>
    function First(): T; override;

    ///  <summary>Returns the first element or a default if the set is empty.</summary>
    ///  <param name="ADefault">The default value returned if the set is empty.</param>
    ///  <returns>The first element in set if the set is not empty; otherwise <paramref name="ADefault"/> is returned.</returns>
    function FirstOrDefault(const ADefault: T): T; override;

    ///  <summary>Returns the last element.</summary>
    ///  <returns>The last element in the set.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The set is empty.</exception>
    function Last(): T; override;

    ///  <summary>Returns the last element or a default if the set is empty.</summary>
    ///  <param name="ADefault">The default value returned if the set is empty.</param>
    ///  <returns>The last element in set if the set is not empty; otherwise <paramref name="ADefault"/> is returned.</returns>
    function LastOrDefault(const ADefault: T): T; override;

    ///  <summary>Returns the single element stored in the set.</summary>
    ///  <returns>The element in set.</returns>
    ///  <remarks>This method checks if the set contains just one element, in which case it is returned.</remarks>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The set is empty.</exception>
    ///  <exception cref="DeHL.Exceptions|ECollectionNotOneException">There is more than one element in the set.</exception>
    function Single(): T; override;

    ///  <summary>Returns the single element stored in the set, or a default value.</summary>
    ///  <param name="ADefault">The default value returned if there is less or more elements in the set.</param>
    ///  <returns>The element in the set if the condition is satisfied; <paramref name="ADefault"/> is returned otherwise.</returns>
    ///  <remarks>This method checks if the set contains just one element, in which case it is returned. Otherwise
    ///  the value in <paramref name="ADefault"/> is returned.</remarks>
    function SingleOrDefault(const ADefault: T): T; override;
  end;

  ///  <summary>The generic <c>set</c> collection designed to store objects.</summary>
  ///  <remarks>This type uses an AVL tree to store its objects.</remarks>
  TObjectSortedSet<T: class> = class(TSortedSet<T>)
  private
    FOwnsObjects: Boolean;

  protected
    ///  <summary>Frees the object that was removed from the collection.</summary>
    ///  <param name="AElement">The object that was removed from the collection.</param>
    procedure HandleElementRemoved(const AElement: T); override;

  public
    ///  <summary>Specifies whether this set owns the objects stored in it.</summary>
    ///  <returns><c>True</c> if the set owns its objects; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the set controls the life-time of the stored objects.</remarks>
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
  end;

type
  ///  <summary>The generic <c>set</c> collection.</summary>
  ///  <remarks>This type uses an internal array to store its values.</remarks>
  TArraySet<T> = class(TEnexCollection<T>, ISet<T>, IDynamic)
  private type
    {$REGION 'Internal Types'}
    TEnumerator = class(TEnumerator<T>)
    private
      FVer: NativeInt;
      FSet: TArraySet<T>;
      FCurrentIndex: NativeInt;

    public
      { Constructor }
      constructor Create(const ASet: TArraySet<T>);

      { Destructor }
      destructor Destroy(); override;

      function GetCurrent(): T; override;
      function MoveNext(): Boolean; override;
    end;
    {$ENDREGION}

  private var
    FArray: TArray<T>;
    FLength: NativeInt;
    FVer: NativeInt;

  protected
    ///  <summary>Returns the number of elements in the set.</summary>
    ///  <returns>A positive value specifying the number of elements in the set.</returns>
    function GetCount(): NativeInt; override;

    ///  <summary>Returns the current capacity.</summary>
    ///  <returns>A positive number that specifies the number of elements that the set can hold before it
    ///  needs to grow again.</returns>
    ///  <remarks>The value of this method is greater or equal to the amount of elements in the set. If this value
    ///  is greater then the number of elements, it means that the set has some extra capacity to operate upon.</remarks>
    function GetCapacity(): NativeInt;
  public
    ///  <summary>Creates a new instance of this class.</summary>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AInitialCapacity">The set's initial capacity.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AInitialCapacity: NativeInt); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ACollection">A collection to copy elements from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const ACollection: IEnumerable<T>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy elements from.</param>
    ///  <remarks>The default type object is requested.</remarks>
    constructor Create(const AArray: array of T); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AInitialCapacity">The set's initial capacity.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>; const AInitialCapacity: NativeInt); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="ACollection">A collection to copy elements from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>; const ACollection: IEnumerable<T>); overload;

    ///  <summary>Creates a new instance of this class.</summary>
    ///  <param name="AArray">An array to copy elements from.</param>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ARules"/> is <c>nil</c>.</exception>
    constructor Create(const ARules: TRules<T>; const AArray: array of T); overload;

    ///  <summary>Destroys this instance.</summary>
    ///  <remarks>Do not call this method directly, call <c>Free</c> instead</remarks>
    destructor Destroy(); override;

    ///  <summary>Clears the contents of the set.</summary>
    ///  <remarks>This method clears the set and invokes type object's cleaning routines for each element.</remarks>
    procedure Clear();

    ///  <summary>Adds an element to the set.</summary>
    ///  <param name="AValue">The value to add.</param>
    ///  <remarks>If the set already contains the given value, nothing happens.</remarks>
    procedure Add(const AValue: T);

    ///  <summary>Removes a given value from the set.</summary>
    ///  <param name="AValue">The value to remove.</param>
    ///  <remarks>If the set does not contain the given value, nothing happens.</remarks>
    procedure Remove(const AValue: T);

    ///  <summary>Checks whether the set contains a given value.</summary>
    ///  <param name="AValue">The value to check.</param>
    ///  <returns><c>True</c> if the value was found in the set; <c>False</c> otherwise.</returns>
    function Contains(const AValue: T): Boolean;

    ///  <summary>Specifies the number of elements in the set.</summary>
    ///  <returns>A positive value specifying the number of elements in the set.</returns>
    property Count: NativeInt read FLength;

    ///  <summary>Specifies the current capacity.</summary>
    ///  <returns>A positive number that specifies the number of elements that the set can hold before it
    ///  needs to grow again.</returns>
    ///  <remarks>The value of this property is greater or equal to the amount of elements in the set. If this value
    ///  if greater then the number of elements, it means that the set has some extra capacity to operate upon.</remarks>
    property Capacity: NativeInt read GetCapacity;

    ///  <summary>Returns a new enumerator object used to enumerate this set.</summary>
    ///  <remarks>This method is usually called by compiler generated code. Its purpose is to create an enumerator
    ///  object that is used to actually traverse the set.</remarks>
    ///  <returns>An enumerator object.</returns>
    function GetEnumerator(): IEnumerator<T>; override;

    ///  <summary>Removes the excess capacity from the set.</summary>
    ///  <remarks>This method can be called manually to force the set to drop the extra capacity it might hold. For example,
    ///  after performing some massive operations of a big list, call this method to ensure that all extra memory held by the
    ///  set is released.</remarks>
    procedure Shrink();

    ///  <summary>Forces the set to increase its capacity.</summary>
    ///  <remarks>Call this method to force the set to increase its capacity ahead of time. Manually adjusting the capacity
    ///  can be useful in certain situations.</remarks>
    procedure Grow();

    ///  <summary>Copies the values stored in the set to a given array.</summary>
    ///  <param name="AArray">An array where to copy the contents of the set.</param>
    ///  <param name="AStartIndex">The index into the array at which the copying begins.</param>
    ///  <remarks>This method assumes that <paramref name="AArray"/> has enough space to hold the contents of the set.</remarks>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AStartIndex"/> is out of bounds.</exception>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfSpaceException">There array is not long enough.</exception>
    procedure CopyTo(var AArray: array of T; const AStartIndex: NativeInt); overload; override;

    ///  <summary>Checks whether the set is empty.</summary>
    ///  <returns><c>True</c> if the set is empty; <c>False</c> otherwise.</returns>
    ///  <remarks>This method is the recommended way of detecting if the set is empty.</remarks>
    function Empty(): Boolean; override;

    ///  <summary>Returns the biggest element.</summary>
    ///  <returns>An element from the set considered to have the biggest value.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The set is empty.</exception>
    function Max(): T; override;

    ///  <summary>Returns the smallest element.</summary>
    ///  <returns>An element from the set considered to have the smallest value.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The set is empty.</exception>
    function Min(): T; override;

    ///  <summary>Returns the first element.</summary>
    ///  <returns>The first element in the set.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The set is empty.</exception>
    function First(): T; override;

    ///  <summary>Returns the first element or a default if the set is empty.</summary>
    ///  <param name="ADefault">The default value returned if the set is empty.</param>
    ///  <returns>The first element in set if the set is not empty; otherwise <paramref name="ADefault"/> is returned.</returns>
    function FirstOrDefault(const ADefault: T): T; override;

    ///  <summary>Returns the last element.</summary>
    ///  <returns>The last element in the set.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The set is empty.</exception>
    function Last(): T; override;

    ///  <summary>Returns the last element or a default if the set is empty.</summary>
    ///  <param name="ADefault">The default value returned if the set is empty.</param>
    ///  <returns>The last element in set if the set is not empty; otherwise <paramref name="ADefault"/> is returned.</returns>
    function LastOrDefault(const ADefault: T): T; override;

    ///  <summary>Returns the single element stored in the set.</summary>
    ///  <returns>The element in set.</returns>
    ///  <remarks>This method checks if the set contains just one element, in which case it is returned.</remarks>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The set is empty.</exception>
    ///  <exception cref="DeHL.Exceptions|ECollectionNotOneException">There is more than one element in the set.</exception>
    function Single(): T; override;

    ///  <summary>Returns the single element stored in the set, or a default value.</summary>
    ///  <param name="ADefault">The default value returned if there is less or more elements in the set.</param>
    ///  <returns>The element in the set if the condition is satisfied; <paramref name="ADefault"/> is returned otherwise.</returns>
    ///  <remarks>This method checks if the set contains just one element, in which case it is returned. Otherwise
    ///  the value in <paramref name="ADefault"/> is returned.</remarks>
    function SingleOrDefault(const ADefault: T): T; override;

    ///  <summary>Aggregates a value based on the set's elements.</summary>
    ///  <param name="AAggregator">The aggregator method.</param>
    ///  <returns>A value that contains the set's aggregated value.</returns>
    ///  <remarks>This method returns the first element if the set only has one element. Otherwise,
    ///  <paramref name="AAggregator"/> is invoked for each two elements (first and second; then the result of the first two
    ///  and the third, and so on). The simples example of aggregation is the "sum" operation where you can obtain the sum of all
    ///  elements in the value.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AAggregator"/> is <c>nil</c>.</exception>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The set is empty.</exception>
    function Aggregate(const AAggregator: TFunc<T, T, T>): T; override;

    ///  <summary>Aggregates a value based on the set's elements.</summary>
    ///  <param name="AAggregator">The aggregator method.</param>
    ///  <param name="ADefault">The default value returned if the set is empty.</param>
    ///  <returns>A value that contains the set's aggregated value. If the set is empty, <paramref name="ADefault"/> is returned.</returns>
    ///  <remarks>This method returns the first element if the set only has one element. Otherwise,
    ///  <paramref name="AAggregator"/> is invoked for each two elements (first and second; then the result of the first two
    ///  and the third, and so on). The simples example of aggregation is the "sum" operation where you can obtain the sum of all
    ///  elements in the value.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="AAggregator"/> is <c>nil</c>.</exception>
    function AggregateOrDefault(const AAggregator: TFunc<T, T, T>; const ADefault: T): T; override;

    ///  <summary>Returns the element at a given position.</summary>
    ///  <param name="AIndex">The index from which to return the element.</param>
    ///  <returns>The element from the specified position.</returns>
    ///  <exception cref="DeHL.Exceptions|ECollectionEmptyException">The set is empty.</exception>
    ///  <exception cref="DeHL.Exceptions|EArgumentOutOfRangeException"><paramref name="AIndex"/> is out of bounds.</exception>
    function ElementAt(const AIndex: NativeInt): T; override;

    ///  <summary>Returns the element at a given position.</summary>
    ///  <param name="AIndex">The index from which to return the element.</param>
    ///  <param name="ADefault">The default value returned if the set is empty.</param>
    ///  <returns>The element from the specified position if the set is not empty and the position is not out of bounds; otherwise
    ///  the value of <paramref name="ADefault"/> is returned.</returns>
    function ElementAtOrDefault(const AIndex: NativeInt; const ADefault: T): T; override;

    ///  <summary>Check whether at least one element in the set satisfies a given predicate.</summary>
    ///  <param name="APredicate">The predicate to check for each element.</param>
    ///  <returns><c>True</c> if the at least one element satisfies a given predicate; <c>False</c> otherwise.</returns>
    ///  <remarks>This method traverses the whole set and checks the value of the predicate for each element. This method
    ///  stops on the first element for which the predicate returns <c>True</c>. The logical equivalent of this operation is "OR".</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="APredicate"/> is <c>nil</c>.</exception>
    function Any(const APredicate: TFunc<T, Boolean>): Boolean; override;

    ///  <summary>Checks that all elements in the set satisfy a given predicate.</summary>
    ///  <param name="APredicate">The predicate to check for each element.</param>
    ///  <returns><c>True</c> if all elements satisfy a given predicate; <c>False</c> otherwise.</returns>
    ///  <remarks>This method traverses the whole set and checks the value of the predicate for each element. This method
    ///  stops on the first element for which the predicate returns <c>False</c>. The logical equivalent of this operation is "AND".</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="APredicate"/> is <c>nil</c>.</exception>
    function All(const APredicate: TFunc<T, Boolean>): Boolean; override;

    ///  <summary>Checks whether the elements in this set are equal to the elements in another collection.</summary>
    ///  <param name="ACollection">The collection to compare to.</param>
    ///  <returns><c>True</c> if the collections are equal; <c>False</c> if the collections are different.</returns>
    ///  <remarks>This methods checks that each element at position X in this set is equal to an element at position X in
    ///  the provided collection. If the number of elements in both collections are different, then the collections are considered different.
    ///  Note that comparison of element is done using the type object used by this set. This means that comparing this collection
    ///  to another one might yeild a different result than comparing the other collection to this one.</remarks>
    ///  <exception cref="DeHL.Exceptions|ENilArgumentException"><paramref name="ACollection"/> is <c>nil</c>.</exception>
    function EqualsTo(const ACollection: IEnumerable<T>): Boolean; override;
  end;

  ///  <summary>The generic <c>set</c> collection designed to store objects.</summary>
  ///  <remarks>This type uses an internal array to store its objects.</remarks>
  TObjectArraySet<T: class> = class(TArraySet<T>)
  private
    FOwnsObjects: Boolean;

  protected
    ///  <summary>Frees the object that was removed from the collection.</summary>
    ///  <param name="AElement">The object that was removed from the collection.</param>
    procedure HandleElementRemoved(const AElement: T); override;

  public
    ///  <summary>Specifies whether this set owns the objects stored in it.</summary>
    ///  <returns><c>True</c> if the set owns its objects; <c>False</c> otherwise.</returns>
    ///  <remarks>This property controls the way the set controls the life-time of the stored objects.</remarks>
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
  end;


implementation

{ THashSet<T> }

procedure THashSet<T>.Add(const AValue: T);
begin
 { Call insert }
 Insert(AValue, False);
end;

procedure THashSet<T>.Clear;
var
  I: NativeInt;
begin
  if FCount > 0 then
    for I := 0 to Length(FBucketArray) - 1 do
      FBucketArray[I] := -1;

  for I := 0 to Length(FEntryArray) - 1 do
    if FEntryArray[I].FHashCode >= 0 then
    begin
      HandleElementRemoved(FEntryArray[I].FKey);
      FEntryArray[I].FKey := default(T);
    end;

  if Length(FEntryArray) > 0 then
     FillChar(FEntryArray[0], Length(FEntryArray) * SizeOf(TEntry), 0);

  FFreeList := -1;
  FCount := 0;
  FFreeCount := 0;

  Inc(FVer);
end;

function THashSet<T>.Contains(const AValue: T): Boolean;
begin
  Result := (FindEntry(AValue) >= 0);
end;

procedure THashSet<T>.CopyTo(var AArray: array of T; const AStartIndex: NativeInt);
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
       AArray[X] := FEntryArray[I].FKey;
       Inc(X);
    end;
  end;
end;

constructor THashSet<T>.Create;
begin
  Create(TRules<T>.Default);
end;

constructor THashSet<T>.Create(const AInitialCapacity: NativeInt);
begin
  Create(TRules<T>.Default, AInitialCapacity);
end;

constructor THashSet<T>.Create(const ACollection: IEnumerable<T>);
begin
  Create(TRules<T>.Default, ACollection);
end;

constructor THashSet<T>.Create(const ARules: TRules<T>; const AInitialCapacity: NativeInt);
begin
  { Call the upper constructor}
  inherited Create(ARules);

  FVer := 0;
  FCount := 0;
  FFreeCount := 0;
  FFreeList := 0;

  InitializeInternals(AInitialCapacity);
end;

constructor THashSet<T>.Create(const ARules: TRules<T>; const ACollection: IEnumerable<T>);
var
  V : T;
begin
  { Call upper constructor }
  Create(ARules, CDefaultSize);

  if (ACollection = nil) then
     ExceptionHelper.Throw_ArgumentNilError('ACollection');

  { Pump in all items }
  for V in ACollection do
    Add(V);
end;

constructor THashSet<T>.Create(const ARules: TRules<T>);
begin
  { Call upper constructor }
  Create(ARules, CDefaultSize);
end;

destructor THashSet<T>.Destroy;
begin
  { Clear first }
  Clear();

  inherited;
end;

function THashSet<T>.Empty: Boolean;
begin
  Result := (FCount = 0);
end;

function THashSet<T>.FindEntry(const AKey: T): NativeInt;
var
  HashCode: NativeInt;
  I: NativeInt;
begin
  Result := -1;

  if Length(FBucketArray) > 0 then
  begin
    { Generate the hash code }
    HashCode := Hash(AKey);

    I := FBucketArray[HashCode mod Length(FBucketArray)];

    while I >= 0 do
    begin
      if (FEntryArray[I].FHashCode = HashCode) and ElementRules.AreEqual(FEntryArray[I].FKey, AKey) then
         begin Result := I; Exit; end;

      I := FEntryArray[I].FNext;
    end;
  end;
end;

function THashSet<T>.GetCount: NativeInt;
begin
  Result := (FCount - FFreeCount);
end;

function THashSet<T>.GetEnumerator: IEnumerator<T>;
begin
  Result := THashSet<T>.TEnumerator.Create(Self);
end;

function THashSet<T>.Hash(const AKey: T): NativeInt;
const
  PositiveMask = not NativeInt(1 shl (SizeOf(NativeInt) * 8 - 1));
begin
  Result := PositiveMask and ((PositiveMask and ElementRules.GetHashCode(AKey)) + 1);
end;

procedure THashSet<T>.InitializeInternals(const ACapacity: NativeInt);
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

procedure THashSet<T>.Insert(const AKey: T; const ShouldAdd: Boolean);
var
  FreeList: NativeInt;
  Index: NativeInt;
  HashCode: NativeInt;
  I: NativeInt;
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
    if (FEntryArray[I].FHashCode = HashCode) and ElementRules.AreEqual(FEntryArray[I].FKey, AKey) then
    begin
      if (ShouldAdd) then
        ExceptionHelper.Throw_DuplicateKeyError('AKey');

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
  FEntryArray[FreeList].FNext := FBucketArray[Index];

  FBucketArray[Index] := FreeList;
  Inc(FVer);
end;

procedure THashSet<T>.Remove(const AValue: T);
var
  HashCode, Index, I, RemIndex: NativeInt;
begin
  if Length(FBucketArray) > 0 then
  begin
    { Generate the hash code }
    HashCode := Hash(AValue);

    Index := HashCode mod Length(FBucketArray);
    RemIndex := -1;

    I := FBucketArray[Index];

    while I >= 0 do
    begin
      if (FEntryArray[I].FHashCode = HashCode) and ElementRules.AreEqual(FEntryArray[I].FKey, AValue) then
      begin

        if RemIndex < 0 then
        begin
          FBucketArray[Index] := FEntryArray[I].FNext;
        end else
        begin
          FEntryArray[RemIndex].FNext := FEntryArray[I].FNext;
        end;

        FEntryArray[I].FHashCode := -1;
        FEntryArray[I].FNext := FFreeList;
        FEntryArray[I].FKey := default(T);

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

procedure THashSet<T>.Resize;
var
  XPrime, I, Index: NativeInt;
  NArr: TBucketArray;
begin
  XPrime := FCount * 2;

  SetLength(NArr, XPrime);

  for I := 0 to Length(NArr) - 1 do
  begin
    NArr[I] := -1;
  end;

  SetLength(FEntryArray, XPrime);

  for I := 0 to FCount - 1 do
  begin
    Index := FEntryArray[I].FHashCode mod XPrime;
    FEntryArray[I].FNext := NArr[Index];
    NArr[Index] := I;
  end;

  { Reset bucket array }
  FBucketArray := nil;
  FBucketArray := NArr;
end;

{ THashSet<T>.TPairEnumerator }

constructor THashSet<T>.TEnumerator.Create(const ADict : THashSet<T>);
begin
  { Initialize }
  FDict := ADict;
  KeepObjectAlive(FDict);

  FCurrentIndex := 0;
  FVer := ADict.FVer;
end;

destructor THashSet<T>.TEnumerator.Destroy;
begin
  ReleaseObject(FDict);
  inherited;
end;

function THashSet<T>.TEnumerator.GetCurrent: T;
begin
  if FVer <> FDict.FVer then
    ExceptionHelper.Throw_CollectionChangedError();

  Result := FValue;
end;

function THashSet<T>.TEnumerator.MoveNext: Boolean;
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

constructor THashSet<T>.Create(const AArray: array of T);
begin
  Create(TRules<T>.Default, AArray);
end;

constructor THashSet<T>.Create(const ARules: TRules<T>;
  const AArray: array of T);
var
  I: NativeInt;
begin
  { Call upper constructor }
  Create(ARules, CDefaultSize);

  { Copy all in }
  for I := 0 to Length(AArray) - 1 do
  begin
    Add(AArray[I]);
  end;
end;

{ TObjectHashSet<T> }

procedure TObjectHashSet<T>.HandleElementRemoved(const AElement: T);
begin
  TObject(AElement).Free;
end;

{ TSortedSet<T> }

procedure TSortedSet<T>.Add(const AValue: T);
begin
  { Insert the value }
  Insert(AValue);
end;

procedure TSortedSet<T>.BalanceTreesAfterRemoval(const ANode: TNode);
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

procedure TSortedSet<T>.Clear;
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

function TSortedSet<T>.Contains(const AValue: T): Boolean;
begin
  Result := FindNodeWithKey(AValue) <> nil;
end;

procedure TSortedSet<T>.CopyTo(var AArray: array of T; const AStartIndex: NativeInt);
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
    AArray[X] := LNode.FKey;

    { Navigate further in the tree }
    LNode := WalkToTheRight(LNode);

    { Increment the index }
    Inc(X);
  end;
end;

constructor TSortedSet<T>.Create(const AAscending: Boolean);
begin
  Create(TRules<T>.Default, AAscending);
end;

constructor TSortedSet<T>.Create(const ACollection: IEnumerable<T>;
  const AAscending: Boolean);
begin
  Create(TRules<T>.Default, ACollection, AAscending);
end;

constructor TSortedSet<T>.Create(const ARules: TRules<T>;
  const ACollection: IEnumerable<T>; const AAscending: Boolean);
var
  V: T;
begin
  { Call upper constructor }
  Create(ARules, AAscending);

  if (ACollection = nil) then
     ExceptionHelper.Throw_ArgumentNilError('ACollection');

  { Pump in all items }
  for V in ACollection do
  begin
    Add(V);
  end;
end;

constructor TSortedSet<T>.Create(const ARules: TRules<T>; const AAscending: Boolean);
begin
  { Call the upper constructor }
  inherited Create(ARules);

  FVer := 0;
  FCount := 0;

  if AAscending then
    FSignFix := 1
  else
    FSignFix := -1;
end;

destructor TSortedSet<T>.Destroy;
begin
  { Clear first }
  Clear();

  inherited;
end;

function TSortedSet<T>.Empty: Boolean;
begin
  Result := (FRoot = nil);
end;

function TSortedSet<T>.FindLeftMostNode: TNode;
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

function TSortedSet<T>.FindNodeWithKey(const AValue: T): TNode;
var
  LNode: TNode;
  Compare: NativeInt;
begin
  { Get root }
  LNode := FRoot;

  while LNode <> nil do
  begin
	  Compare := ElementRules.Compare(AValue, LNode.FKey) * FSignFix;

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

function TSortedSet<T>.FindRightMostNode: TNode;
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

function TSortedSet<T>.First: T;
begin
  { Check there are elements in the set }
  if FRoot = nil then
    ExceptionHelper.Throw_CollectionEmptyError();

  Result := FindLeftMostNode().FKey
end;

function TSortedSet<T>.FirstOrDefault(const ADefault: T): T;
begin
  { Check there are elements in the set }
  if FRoot = nil then
    Result := ADefault
  else
    Result := FindLeftMostNode().FKey
end;

function TSortedSet<T>.GetCount: NativeInt;
begin
  Result := FCount;
end;

function TSortedSet<T>.GetEnumerator: IEnumerator<T>;
begin
  Result := TEnumerator.Create(Self);
end;

procedure TSortedSet<T>.Insert(const AValue: T);
var
  LNode: TNode;
  Compare: NativeInt;
begin
  { First one get special treatment! }
  if FRoot = nil then
  begin
    FRoot := MakeNode(AValue, nil);

    { Increase markers }
    Inc(FCount);
    Inc(FVer);

    { [ADDED NEW] Exit function }
    Exit;
  end;

  { Get root }
  LNode := FRoot;

  while true do
  begin
	  Compare := ElementRules.Compare(AValue, LNode.FKey) * FSignFix;

    if Compare < 0 then
    begin
      if LNode.FLeft <> nil then
        LNode := LNode.FLeft
      else
      begin
        { Create a new node }
        LNode.FLeft := MakeNode(AValue, LNode);
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
        LNode.FRight := MakeNode(AValue, LNode);
        Inc(LNode.FBalance);

        { [ADDED NEW] Exit function! }
        break;
      end;
    end else
    begin
      { Found a node with the same key. }
      { [NOTHING] Exit function }
      Exit();
    end;
  end;

  { Rebalance the tree }
  ReBalanceSubTreeOnInsert(LNode);

  Inc(FCount);
  Inc(FVer);
end;

function TSortedSet<T>.Last: T;
begin
  { Check there are elements in the set }
  if FRoot = nil then
    ExceptionHelper.Throw_CollectionEmptyError();

  Result := FindRightMostNode().FKey
end;

function TSortedSet<T>.LastOrDefault(const ADefault: T): T;
begin
  { Check there are elements in the set }
  if FRoot = nil then
    Result := ADefault
  else
    Result := FindRightMostNode().FKey
end;

function TSortedSet<T>.MakeNode(const AValue: T; const ARoot: TNode): TNode;
begin
  Result := TNode.Create();
  Result.FKey := AValue;
  Result.FParent := ARoot;
end;

function TSortedSet<T>.Max: T;
begin
  { Check there are elements in the set }
  if FRoot = nil then
    ExceptionHelper.Throw_CollectionEmptyError();

  if FSignFix = 1 then
    Result := FindRightMostNode().FKey
  else
    Result := FindLeftMostNode().FKey;
end;

function TSortedSet<T>.Min: T;
begin
  { Check there are elements in the set }
  if FRoot = nil then
    ExceptionHelper.Throw_CollectionEmptyError();

  if FSignFix = 1 then
    Result := FindLeftMostNode().FKey
  else
    Result := FindRightMostNode().FKey;
end;

procedure TSortedSet<T>.ReBalanceSubTreeOnInsert(const ANode: TNode);
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

procedure TSortedSet<T>.Remove(const AValue: T);
var
  LNode: TNode;

begin
  { Get root }
  LNode := FindNodeWithKey(AValue);

  { Remove and rebalance the tree accordingly }
  if LNode = nil then
    Exit;

  { .. Do da dew! }
  BalanceTreesAfterRemoval(LNode);

  { Kill the node }
  LNode.Free;

  Dec(FCount);
  Inc(FVer);
end;

function TSortedSet<T>.Single: T;
begin
  { Check there are elements in the set }
  if FRoot = nil then
    ExceptionHelper.Throw_CollectionEmptyError();

  { Check for more than one }
  if (FRoot.FLeft <> nil) or (FRoot.FRight <> nil) then
    ExceptionHelper.Throw_CollectionHasMoreThanOneElement();

  Result := FRoot.FKey;
end;

function TSortedSet<T>.SingleOrDefault(const ADefault: T): T;
begin
  { Check there are elements in the set }
  if FRoot = nil then
    Exit(ADefault);

  { Check for more than one }
  if (FRoot.FLeft <> nil) or (FRoot.FRight <> nil) then
    ExceptionHelper.Throw_CollectionHasMoreThanOneElement();

  Result := FRoot.FKey;
end;

procedure TSortedSet<T>.RecursiveClear(const ANode: TNode);
begin
  if ANode.FLeft <> nil then
    RecursiveClear(ANode.FLeft);

  if ANode.FRight <> nil then
    RecursiveClear(ANode.FRight);

  { Cleanup for Key/Value }
  HandleElementRemoved(ANode.FKey);

  { Finally, free the node itself }
  ANode.Free;
end;

function TSortedSet<T>.WalkToTheRight(const ANode: TNode): TNode;
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

constructor TSortedSet<T>.Create(const AArray: array of T; const AAscending: Boolean);
begin
  Create(TRules<T>.Default, AArray, AAscending);
end;

constructor TSortedSet<T>.Create(const ARules: TRules<T>; const AArray: array of T;
  const AAscending: Boolean);
var
  I: NativeInt;
begin
  { Call upper constructor }
  Create(ARules, AAscending);

  { Copy all items in }
  for I := 0 to Length(AArray) - 1 do
  begin
    Add(AArray[I]);
  end;
end;

{ TSortedSet<T>.TEnumerator }

constructor TSortedSet<T>.TEnumerator.Create(const ADict: TSortedSet<T>);
begin
  { Initialize }
  FDict := ADict;
  KeepObjectAlive(FDict);

  FNext := ADict.FindLeftMostNode();

  FVer := ADict.FVer;
end;

destructor TSortedSet<T>.TEnumerator.Destroy;
begin
  ReleaseObject(FDict);
  inherited;
end;

function TSortedSet<T>.TEnumerator.GetCurrent: T;
begin
  if FVer <> FDict.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  Result := FValue;
end;

function TSortedSet<T>.TEnumerator.MoveNext: Boolean;
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

{ TObjectSortedSet<T> }

procedure TObjectSortedSet<T>.HandleElementRemoved(const AElement: T);
begin
  TObject(AElement).Free;
end;

{ TArraySet<T> }

procedure TArraySet<T>.Add(const AValue: T);
begin
  if Contains(AValue) then
     Exit;

  if FLength = Length(FArray) then
    Grow();

  { Put the element into the new position }
  FArray[FLength] := AValue;

  Inc(FLength);
  Inc(FVer);
end;

function TArraySet<T>.Aggregate(const AAggregator: TFunc<T, T, T>): T;
var
  I: NativeInt;
begin
  { Check arguments }
  if not Assigned(AAggregator) then
    ExceptionHelper.Throw_ArgumentNilError('AAggregator');

  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  { Select the first element as comparison base }
  Result := FArray[0];

  { Iterate over the last N - 1 elements }
  for I := 1 to FLength - 1 do
  begin
    { Aggregate a value }
    Result := AAggregator(Result, FArray[I]);
  end;
end;

function TArraySet<T>.AggregateOrDefault(const AAggregator: TFunc<T, T, T>; const ADefault: T): T;
var
  I: NativeInt;
begin
  { Check arguments }
  if not Assigned(AAggregator) then
    ExceptionHelper.Throw_ArgumentNilError('AAggregator');

  if FLength = 0 then
    Exit(ADefault);

  { Select the first element as comparison base }
  Result := FArray[0];

  { Iterate over the last N - 1 elements }
  for I := 1 to FLength - 1 do
  begin
    { Aggregate a value }
    Result := AAggregator(Result, FArray[I]);
  end;
end;

function TArraySet<T>.All(const APredicate: TFunc<T, Boolean>): Boolean;
var
  I: NativeInt;
begin
  if not Assigned(APredicate) then
    ExceptionHelper.Throw_ArgumentNilError('APredicate');

  if FLength > 0 then
    for I := 0 to FLength - 1 do
      if not APredicate(FArray[I]) then
        Exit(false);

  Result := true;
end;

function TArraySet<T>.Any(const APredicate: TFunc<T, Boolean>): Boolean;
var
  I: NativeInt;
begin
  if not Assigned(APredicate) then
    ExceptionHelper.Throw_ArgumentNilError('APredicate');

  if FLength > 0 then
    for I := 0 to FLength - 1 do
      if APredicate(FArray[I]) then
        Exit(true);

  Result := false;
end;

procedure TArraySet<T>.Clear;
var
  I: NativeInt;
begin
  { If we need to cleanup }
  for I := 0 to FLength - 1 do
    HandleElementRemoved(FArray[I]);

  { Reset the length }
  FLength := 0;
end;

function TArraySet<T>.Contains(const AValue: T): Boolean;
var
  I: NativeInt;
begin
  Result := false;

  { Search for the value }
  if FLength > 0 then
    for I := 0 to FLength - 1 do
      if ElementRules.AreEqual(FArray[I], AValue) then
      begin
        Result := true;
        Exit;
      end;
end;

procedure TArraySet<T>.CopyTo(var AArray: array of T; const AStartIndex: NativeInt);
var
  I: NativeInt;
begin
  if (AStartIndex >= Length(AArray)) or (AStartIndex < 0) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('AStartIndex');

  { Check for indexes }
  if (Length(AArray) - AStartIndex) < FLength then
     ExceptionHelper.Throw_ArgumentOutOfSpaceError('AArray');

  { Copy all elements safely }
  for I := 0 to FLength - 1 do
    AArray[AStartIndex + I] := FArray[I];
end;

constructor TArraySet<T>.Create(const ACollection: IEnumerable<T>);
begin
  Create(TRules<T>.Default, ACollection);
end;

constructor TArraySet<T>.Create(const AInitialCapacity: NativeInt);
begin
  Create(TRules<T>.Default, AInitialCapacity);
end;

constructor TArraySet<T>.Create;
begin
  Create(TRules<T>.Default);
end;

constructor TArraySet<T>.Create(const ARules: TRules<T>);
begin
  { Call upper constructor }
  Create(ARules, CDefaultSize);
end;

constructor TArraySet<T>.Create(const ARules: TRules<T>; const ACollection: IEnumerable<T>);
var
  V: T;
begin
  { Call upper constructor }
  Create(ARules, CDefaultSize);

  { Initialize instance }
  if (ACollection = nil) then
     ExceptionHelper.Throw_ArgumentNilError('ACollection');

  { Try to copy the given Enumerable }
  for V in ACollection do
    Add(V);
end;

constructor TArraySet<T>.Create(const ARules: TRules<T>; const AInitialCapacity: NativeInt);
begin
  { Call the upper constructor }
  inherited Create(ARules);

  FLength := 0;
  FVer := 0;
  SetLength(FArray, AInitialCapacity);
end;

destructor TArraySet<T>.Destroy;
begin
  { Clear list first }
  Clear();

  inherited;
end;

function TArraySet<T>.ElementAt(const AIndex: NativeInt): T;
begin
  { Simply use the getter }
  if (AIndex >= FLength) or (AIndex < 0) then
    ExceptionHelper.Throw_ArgumentOutOfRangeError('AIndex');

  Result := FArray[AIndex];
end;

function TArraySet<T>.ElementAtOrDefault(const AIndex: NativeInt; const ADefault: T): T;
begin
  { Check range }
  if (AIndex >= FLength) or (AIndex < 0) then
     Result := ADefault
  else
     Result := FArray[AIndex];
end;

function TArraySet<T>.Empty: Boolean;
begin
  Result := (FLength = 0);
end;

function TArraySet<T>.EqualsTo(const ACollection: IEnumerable<T>): Boolean;
var
  V: T;
  I: NativeInt;
begin
  I := 0;

  for V in ACollection do
  begin
    if I >= FLength then
      Exit(false);

    if not ElementRules.AreEqual(FArray[I], V) then
      Exit(false);

    Inc(I);
  end;

  if I < FLength then
    Exit(false);

  Result := true;
end;

function TArraySet<T>.First: T;
begin
  { Check length }
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  Result := FArray[0];
end;

function TArraySet<T>.FirstOrDefault(const ADefault: T): T;
begin
  { Check length }
  if FLength = 0 then
    Result := ADefault
  else
    Result := FArray[0];
end;

function TArraySet<T>.GetCapacity: NativeInt;
begin
  Result := Length(FArray);
end;

function TArraySet<T>.GetCount: NativeInt;
begin
  Result := FLength;
end;

function TArraySet<T>.GetEnumerator: IEnumerator<T>;
begin
  { Create an enumerator }
  Result := TEnumerator.Create(Self);
end;

procedure TArraySet<T>.Grow;
begin
  { Grow the array }
  if FLength < CDefaultSize then
     SetLength(FArray, FLength + CDefaultSize)
  else
     SetLength(FArray, FLength * 2);
end;

function TArraySet<T>.Last: T;
begin
  { Check length }
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  Result := FArray[FLength - 1];
end;

function TArraySet<T>.LastOrDefault(const ADefault: T): T;
begin
  { Check length }
  if FLength = 0 then
    Result := ADefault
  else
    Result := FArray[FLength - 1];
end;

function TArraySet<T>.Max: T;
var
  I: NativeInt;
begin
  { Check length }
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  { Default one }
  Result := FArray[0];

  for I := 1 to FLength - 1 do
    if ElementRules.Compare(FArray[I], Result) > 0 then
      Result := FArray[I];
end;

function TArraySet<T>.Min: T;
var
  I: NativeInt;
begin
  { Check length }
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError();

  { Default one }
  Result := FArray[0];

  for I := 1 to FLength - 1 do
    if ElementRules.Compare(FArray[I], Result) < 0 then
      Result := FArray[I];
end;

procedure TArraySet<T>.Remove(const AValue: T);
var
  I, FoundIndex: NativeInt;
begin
  { Defaults }
  if (FLength = 0) then Exit;
  FoundIndex := -1;

  for I := 0 to FLength - 1 do
  begin
    if ElementRules.AreEqual(FArray[I], AValue) then
    begin
      FoundIndex := I;
      Break;
    end;
  end;

  if FoundIndex > -1 then
  begin
    { Move the list }
    if FLength > 1 then
      for I := FoundIndex to FLength - 2 do
        FArray[I] := FArray[I + 1];

    Dec(FLength);
    Inc(FVer);
  end;
end;

procedure TArraySet<T>.Shrink;
begin
  { Cut the capacity if required }
  if FLength < Capacity then
  begin
    SetLength(FArray, FLength);
  end;
end;

function TArraySet<T>.Single: T;
begin
  { Check length }
  if FLength = 0 then
    ExceptionHelper.Throw_CollectionEmptyError()
  else if FLength > 1 then
    ExceptionHelper.Throw_CollectionHasMoreThanOneElement()
  else
    Result := FArray[0];
end;

function TArraySet<T>.SingleOrDefault(const ADefault: T): T;
begin
  { Check length }
  if FLength = 0 then
    Result := ADefault
  else if FLength > 1 then
    ExceptionHelper.Throw_CollectionHasMoreThanOneElement()
  else
    Result := FArray[0];
end;


constructor TArraySet<T>.Create(const AArray: array of T);
begin
  Create(TRules<T>.Default, AArray);
end;

constructor TArraySet<T>.Create(const ARules: TRules<T>; const AArray: array of T);
var
  I: NativeInt;
begin
  { Call upper constructor }
  Create(ARules, CDefaultSize);

  { Copy array contents }
  for I := 0 to Length(AArray) - 1 do
  begin
    Add(AArray[I]);
  end;
end;

{ TArraySet<T>.TEnumerator }

constructor TArraySet<T>.TEnumerator.Create(const ASet: TArraySet<T>);
begin
  { Initialize }
  FSet := ASet;
  KeepObjectAlive(FSet);

  FCurrentIndex := 0;
  FVer := ASet.FVer;
end;

destructor TArraySet<T>.TEnumerator.Destroy;
begin
  ReleaseObject(FSet);
  inherited;
end;

function TArraySet<T>.TEnumerator.GetCurrent: T;
begin
  if FVer <> FSet.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  if FCurrentIndex > 0 then
    Result := FSet.FArray[FCurrentIndex - 1]
  else
    Result := default(T);
end;

function TArraySet<T>.TEnumerator.MoveNext: Boolean;
begin
  if FVer <> FSet.FVer then
     ExceptionHelper.Throw_CollectionChangedError();

  Result := FCurrentIndex < FSet.FLength;
  Inc(FCurrentIndex);
end;

{ TObjectArraySet<T> }

procedure TObjectArraySet<T>.HandleElementRemoved(const AElement: T);
begin
  TObject(AElement).Free;
end;

end.
