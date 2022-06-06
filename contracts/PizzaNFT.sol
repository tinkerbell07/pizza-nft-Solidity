// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

abstract contract Context {
    function _msgSender() internal view returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the token decimals.
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Returns the token symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the token name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external view returns (address);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address _owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address lpPair,
        uint256
    );

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address lpPair);

    function createPair(address tokenA, address tokenB)
        external
        returns (address lpPair);
}

interface IUniswapV2Pair {
    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

interface AntiSnipe {
    function checkUser(
        address from,
        address to,
        uint256 amt
    ) external returns (bool);

    function setLaunch(
        address _initialLpPair,
        uint32 _liqAddBlock,
        uint64 _liqAddStamp,
        uint8 dec
    ) external;

    function setLpPair(address pair, bool enabled) external;

    function setProtections(
        bool _as,
        bool _ag,
        bool _ab,
        bool _cd,
        bool _algo
    ) external;

    function setGasPriceLimit(uint256 gas) external;

    function removeSniper(address account) external;

    function getSniperAmt() external view returns (uint256);

    function removeBlacklisted(address account) external;

    function isBlacklisted(address account) external view returns (uint256);

    function setBlacklistEnabled(address account, uint256 time) external;

    function setBlacklistEnabledMultiple(
        address[] memory accounts,
        uint256 time
    ) external;

    function setBuyCooldown(uint256 time) external;
}

interface Cashier {
    function whomst() external view returns (address);

    function setReflectionCriteria(uint256 _minPeriod, uint256 _minReflection)
        external;

    function tally(address shareholder, uint256 amount) external;

    function load() external payable;

    function cashout(uint256 gas) external;

    function giveMeWelfarePlease(address hobo) external;

    function getTotalDistributed() external view returns (uint256);

    function getShareholderInfo(address shareholder)
        external
        view
        returns (
            string memory,
            string memory,
            string memory,
            string memory
        );

    function getShareholderRealized(address shareholder)
        external
        view
        returns (uint256);

    function getPendingRewards(address shareholder)
        external
        view
        returns (uint256);

    function initialize() external;
}

contract PizzaNFT is IERC20 {
    // Ownership moved to in-contract for customizability.
    address private _owner;

    mapping(address => uint256) _tOwned;
    mapping(address => bool) lpPairs;
    uint256 private timeSinceLastPair = 0;
    mapping(address => mapping(address => uint256)) _allowances;
    mapping(address => bool) _isFeeExcluded;
    mapping(address => bool) _isDividendExcluded;

    mapping(address => bool) private presaleAddresses;
    bool private allowedPresaleExclusion = true;
    mapping(address => bool) private _liquidityHolders;

    uint256 private startingSupply = 150_000_000_000;

    string private constant _name = "PIZZA NFT";
    string private constant _symbol = "$PIZZA";
    uint8 private _decimals = 18;

    uint256 private _tTotal = startingSupply * (10**uint256(_decimals));

    struct FeesStruct {
        uint16 buyFee;
        uint16 sellFee;
        uint16 transferFee;
    }

    struct StaticValuesStruct {
        uint16 maxBuyTaxes;
        uint16 maxSellTaxes;
        uint16 maxTransferTaxes;
        uint16 masterTaxDivisor;
    }

    struct Ratios {
        uint16 rewards;
        uint16 liquidity;
        uint16 marketing;
        uint16 charity;
        uint16 buyback;
        uint16 total;
    }

    struct Limits {
        uint256 maxTxBuyAmtUI;
        uint256 maxTxSellAmtUI;
        uint256 maxWalletAmtUI;
    }

    FeesStruct public _taxRates =
        FeesStruct({buyFee: 1400, sellFee: 1400, transferFee: 0});

    Ratios public _ratios =
        Ratios({
            rewards: 3,
            liquidity: 3,
            marketing: 6,
            charity: 1,
            buyback: 1,
            total: 14
        });

    StaticValuesStruct public staticVals =
        StaticValuesStruct({
            maxBuyTaxes: 2500,
            maxSellTaxes: 2500,
            maxTransferTaxes: 2500,
            masterTaxDivisor: 10000
        });

    uint256 private maxTBPercent = 15;
    uint256 private maxTBDivisor = 1000;
    uint256 private maxTSPercent = 1;
    uint256 private maxTSDivisor = 100;

    uint256 private maxWPercent = 35;
    uint256 private maxWDivisor = 1000;

    uint256 private _maxTxBuyAmount = (_tTotal * maxTBPercent) / maxTBDivisor;
    uint256 private _maxTxSellAmount = (_tTotal * maxTSPercent) / maxTSDivisor;
    uint256 private _maxWalletSize = (_tTotal * maxWPercent) / maxWDivisor;

    Limits public _limits =
        Limits({
            maxTxBuyAmtUI: (startingSupply * maxTBPercent) / maxTBDivisor,
            maxTxSellAmtUI: (startingSupply * maxTSPercent) / maxTSDivisor,
            maxWalletAmtUI: (startingSupply * maxWPercent) / maxWDivisor
        });

    IUniswapV2Router02 public dexRouter;
    address public lpPair;

    // PCS ROUTER
    address private _routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    address private WBNB;
    address public DEAD = 0x000000000000000000000000000000000000dEaD;
    address private ZERO = 0x0000000000000000000000000000000000000000;

    address payable public _marketingWallet =
        payable(0x837aea71b3A367cAFB5617E457ae3D5a46288875);
    address payable public _charityWallet =
        payable(0x6eAC588745a1103395C8D6fb2F8Ada616E3be492);
    address payable public _buybackWallet =
        payable(0x157eB1AfAE3d7B52D17186b2240813df8CFA804E);

    Cashier reflector;
    uint256 reflectorGas = 300000;

    bool public contractSwapEnabled = false;
    bool public processReflect = false;
    uint256 private swapThreshold = _tTotal / 20000;
    uint256 private swapAmount = (_tTotal * 5) / 1000;
    bool inSwap;
    bool init = false;

    bool public tradingEnabled = false;
    bool public _hasLiqBeenAdded = false;
    AntiSnipe antiSnipe;

    modifier swapping() {
        inSwap = true;
        _;
        inSwap = false;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event ContractSwapEnabledUpdated(bool enabled);
    event AutoLiquify(uint256 amountBNB, uint256 amount);
    event SniperCaught(address sniperAddress);

    constructor() public payable {
        address msgSender = msg.sender;
        _tOwned[msgSender] = _tTotal;

        _owner = msgSender;
        dexRouter = IUniswapV2Router02(_routerAddress);
        lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(
            dexRouter.WETH(),
            address(this)
        );
        lpPairs[lpPair] = true;
        _approve(msg.sender, _routerAddress, type(uint256).max);
        _approve(address(this), _routerAddress, type(uint256).max);

        WBNB = dexRouter.WETH();

        _isFeeExcluded[owner()] = true;
        _isFeeExcluded[address(this)] = true;
        _isDividendExcluded[owner()] = true;
        _isDividendExcluded[lpPair] = true;
        _isDividendExcluded[address(this)] = true;
        _isDividendExcluded[DEAD] = true;
        _isDividendExcluded[ZERO] = true;

        emit Transfer(ZERO, msg.sender, _tTotal);
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function transferOwner(address newOwner) external onlyOwner {
        require(
            newOwner != address(0),
            "Call renounceOwnership to transfer owner to the zero address."
        );
        require(
            newOwner != DEAD,
            "Call renounceOwnership to transfer owner to the zero address."
        );
        _isFeeExcluded[_owner] = false;
        _isDividendExcluded[_owner] = false;
        _isFeeExcluded[newOwner] = true;
        _isDividendExcluded[newOwner] = true;

        if (_tOwned[_owner] > 0) {
            _transfer(_owner, newOwner, _tOwned[_owner]);
        }

        _owner = newOwner;
        emit OwnershipTransferred(_owner, newOwner);
    }

    function renounceOwnership() public virtual onlyOwner {
        _isFeeExcluded[_owner] = false;
        _isDividendExcluded[_owner] = false;
        _owner = address(0);
        emit OwnershipTransferred(_owner, address(0));
    }

    receive() external payable {}

    function totalSupply() external view override returns (uint256) {
        return _tTotal;
    }

    function decimals() external view override returns (uint8) {
        return _decimals;
    }

    function symbol() external view override returns (string memory) {
        return _symbol;
    }

    function name() external view override returns (string memory) {
        return _name;
    }

    function getOwner() external view override returns (address) {
        return owner();
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _tOwned[account];
    }

    function allowance(address holder, address spender)
        external
        view
        override
        returns (uint256)
    {
        return _allowances[holder][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function _approve(
        address sender,
        address spender,
        uint256 amount
    ) private {
        require(sender != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[sender][spender] = amount;
        emit Approval(sender, spender, amount);
    }

    function approveContractContingency() public onlyOwner returns (bool) {
        _approve(address(this), address(dexRouter), type(uint256).max);
        return true;
    }

    function transfer(address recipient, uint256 amount)
        external
        override
        returns (bool)
    {
        return _transfer(msg.sender, recipient, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external override returns (bool) {
        if (_allowances[sender][msg.sender] != type(uint256).max) {
            _allowances[sender][msg.sender] -= amount;
        }

        return _transfer(sender, recipient, amount);
    }

    function changeRouterContingency(address router) external onlyOwner {
        require(!_hasLiqBeenAdded);
        _routerAddress = router;
    }

    function setBlacklistEnabled(address account, uint256 time)
        external
        onlyOwner
    {
        antiSnipe.setBlacklistEnabled(account, time);
    }

    function setBlacklistEnabledMultiple(
        address[] memory accounts,
        uint256 time
    ) external onlyOwner {
        antiSnipe.setBlacklistEnabledMultiple(accounts, time);
    }

    function isBlacklisted(address account) public view returns (uint256) {
        return antiSnipe.isBlacklisted(account);
    }

    function setBuyCooldown(uint256 time) external onlyOwner {
        antiSnipe.setBuyCooldown(time);
    }

    function isFeeExcluded(address account) public view returns (bool) {
        return _isFeeExcluded[account];
    }

    function isDividendExcluded(address account) public view returns (bool) {
        return _isDividendExcluded[account];
    }

    function setInitializers(address aInitializer, address cInitializer)
        external
        onlyOwner
    {
        require(
            cInitializer != address(this) &&
                aInitializer != address(this) &&
                cInitializer != aInitializer
        );
        reflector = Cashier(cInitializer);
        antiSnipe = AntiSnipe(aInitializer);
    }

    function removeSniper(address account) external onlyOwner {
        antiSnipe.removeSniper(account);
    }

    function removeBlacklisted(address account) external onlyOwner {
        antiSnipe.removeBlacklisted(account);
    }

    function getSniperAmt() public view returns (uint256) {
        return antiSnipe.getSniperAmt();
    }

    function setProtectionSettings(
        bool _antiSnipe,
        bool _antiGas,
        bool _antiBlock,
        bool _cooldown,
        bool _antiSpecial
    ) external onlyOwner {
        antiSnipe.setProtections(
            _antiSnipe,
            _antiGas,
            _antiBlock,
            _cooldown,
            _antiSpecial
        );
    }

    function setGasPriceLimit(uint256 gas) external onlyOwner {
        require(gas >= 75, "Too low.");
        antiSnipe.setGasPriceLimit(gas);
    }

    function enableTrading() public onlyOwner {
        require(!tradingEnabled, "Trading already enabled!");
        require(_hasLiqBeenAdded, "Liquidity must be added.");
        if (address(antiSnipe) == address(0)) {
            antiSnipe = AntiSnipe(address(this));
        }
        try
            antiSnipe.setLaunch(
                lpPair,
                uint32(block.number),
                uint64(block.timestamp),
                _decimals
            )
        {} catch {}
        tradingEnabled = true;
    }

    function setDividendExcluded(address holder, bool enabled)
        public
        onlyOwner
    {
        require(holder != address(this) && holder != lpPair);
        _isDividendExcluded[holder] = enabled;
        if (enabled) {
            reflector.tally(holder, 0);
        } else {
            reflector.tally(holder, _tOwned[holder]);
        }
    }

    function setExcludedFromFees(address account, bool enabled)
        public
        onlyOwner
    {
        _isFeeExcluded[account] = enabled;
    }

    function setTaxes(
        uint16 buyFee,
        uint16 sellFee,
        uint16 transferFee
    ) external onlyOwner {
        require(
            buyFee <= staticVals.maxBuyTaxes &&
                sellFee <= staticVals.maxSellTaxes &&
                transferFee <= staticVals.maxTransferTaxes
        );
        _taxRates.buyFee = buyFee;
        _taxRates.sellFee = sellFee;
        _taxRates.transferFee = transferFee;
    }

    function setRatios(
        uint16 rewards,
        uint16 liquidity,
        uint16 marketing,
        uint16 charity,
        uint16 buyback
    ) external onlyOwner {
        _ratios.rewards = rewards;
        _ratios.liquidity = liquidity;
        _ratios.marketing = marketing;
        _ratios.charity = charity;
        _ratios.buyback = buyback;
        _ratios.total = rewards + liquidity + marketing + charity + buyback;
    }

    function setWallets(
        address payable marketing,
        address payable charity,
        address payable buyback
    ) external onlyOwner {
        _marketingWallet = payable(marketing);
        _charityWallet = payable(charity);
        _buybackWallet = payable(buyback);
    }

    function setContractSwapSettings(bool _enabled, bool processReflectEnabled)
        external
        onlyOwner
    {
        contractSwapEnabled = _enabled;
        processReflect = processReflectEnabled;
    }

    function setSwapSettings(
        uint256 thresholdPercent,
        uint256 thresholdDivisor,
        uint256 amountPercent,
        uint256 amountDivisor
    ) external onlyOwner {
        swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
        swapAmount = (_tTotal * amountPercent) / amountDivisor;
    }

    function setReflectionCriteria(
        uint256 _minPeriod,
        uint256 _minReflection,
        uint256 minReflectionMultiplier
    ) external onlyOwner {
        _minReflection = _minReflection * 10**minReflectionMultiplier;
        reflector.setReflectionCriteria(_minPeriod, _minReflection);
    }

    function setReflectorSettings(uint256 gas) external onlyOwner {
        require(gas < 750000);
        reflectorGas = gas;
    }

    function giveMeWelfarePlease() external {
        reflector.giveMeWelfarePlease(msg.sender);
    }

    function getTotalReflected() external view returns (uint256) {
        return reflector.getTotalDistributed();
    }

    function getUserInfo(address shareholder)
        external
        view
        returns (
            string memory,
            string memory,
            string memory,
            string memory
        )
    {
        return reflector.getShareholderInfo(shareholder);
    }

    function getUserRealizedGains(address shareholder)
        external
        view
        returns (uint256)
    {
        return reflector.getShareholderRealized(shareholder);
    }

    function getUserUnpaidEarnings(address shareholder)
        external
        view
        returns (uint256)
    {
        return reflector.getPendingRewards(shareholder);
    }

    function setNewRouter(address newRouter) public onlyOwner {
        IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
        address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(
            address(this),
            _newRouter.WETH()
        );
        if (get_pair == address(0)) {
            lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(
                address(this),
                _newRouter.WETH()
            );
        } else {
            lpPair = get_pair;
        }
        dexRouter = _newRouter;
        _approve(address(this), address(dexRouter), type(uint256).max);
    }

    function setLpPair(address pair, bool enabled) external onlyOwner {
        if (enabled == false) {
            lpPairs[pair] = false;
            antiSnipe.setLpPair(pair, false);
        } else {
            if (timeSinceLastPair != 0) {
                require(
                    block.timestamp - timeSinceLastPair > 3 days,
                    "Cannot set a new pair this week!"
                );
            }
            lpPairs[pair] = true;
            timeSinceLastPair = block.timestamp;
            antiSnipe.setLpPair(pair, true);
        }
    }

    function setMaxTxPercent(
        uint256 percentBuy,
        uint256 divisorBuy,
        uint256 percentSell,
        uint256 divisorSell
    ) public onlyOwner {
        require(
            (_tTotal * percentBuy) / divisorBuy >= (_tTotal / 1000) &&
                (_tTotal * percentSell) / divisorSell >= (_tTotal / 1000),
            "Max Transaction amt must be above 0.1% of total supply."
        );
        _maxTxBuyAmount = (_tTotal * percentBuy) / divisorBuy;
        _maxTxSellAmount = (_tTotal * percentSell) / divisorSell;
        _limits.maxTxBuyAmtUI = (startingSupply * percentBuy) / divisorBuy;
        _limits.maxTxSellAmtUI = (startingSupply * percentSell) / divisorSell;
    }

    function setMaxWalletSize(uint256 percent, uint256 divisor)
        public
        onlyOwner
    {
        uint256 check = (_tTotal * percent) / divisor;
        require(
            check >= (_tTotal / 1000),
            "Max Wallet amt must be above 0.1% of total supply."
        );
        _maxWalletSize = check;
        _limits.maxWalletAmtUI = (startingSupply * percent) / divisor;
    }

    function excludePresaleAddresses(address router, address presale)
        external
        onlyOwner
    {
        require(allowedPresaleExclusion, "Function already used.");
        if (router == presale) {
            _liquidityHolders[presale] = true;
            presaleAddresses[presale] = true;
            setExcludedFromFees(presale, true);
            setDividendExcluded(presale, true);
        } else {
            _liquidityHolders[router] = true;
            _liquidityHolders[presale] = true;
            presaleAddresses[router] = true;
            presaleAddresses[presale] = true;
            setExcludedFromFees(router, true);
            setExcludedFromFees(presale, true);
            setDividendExcluded(router, true);
            setDividendExcluded(presale, true);
        }
    }

    function _hasLimits(address from, address to) private view returns (bool) {
        return
            from != owner() &&
            to != owner() &&
            !_liquidityHolders[to] &&
            !_liquidityHolders[from] &&
            to != DEAD &&
            to != address(0) &&
            from != address(this);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal returns (bool) {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        if (_hasLimits(from, to)) {
            if (!tradingEnabled) {
                revert("Trading not yet enabled!");
            }

            if (lpPairs[from]) {
                require(
                    amount <= _maxTxBuyAmount,
                    "Transfer amount exceeds the maxTxAmount."
                );
            } else if (lpPairs[to]) {
                require(
                    amount <= _maxTxSellAmount,
                    "Transfer amount exceeds the maxTxAmount."
                );
            }
            if (to != _routerAddress && !lpPairs[to]) {
                require(
                    balanceOf(to) + amount <= _maxWalletSize,
                    "Transfer amount exceeds the maxWalletSize."
                );
            }
        }

        bool takeFee = true;

        if (_isFeeExcluded[from] || _isFeeExcluded[to]) {
            takeFee = false;
        }

        return _finalizeTransfer(from, to, amount, takeFee);
    }

    function _finalizeTransfer(
        address from,
        address to,
        uint256 amount,
        bool takeFee
    ) internal returns (bool) {
        if (!_hasLiqBeenAdded) {
            _checkLiquidityAdd(from, to);
            if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
                revert("Only owner can transfer at this time.");
            }
        }

        if (_hasLimits(from, to)) {
            bool checked;
            try antiSnipe.checkUser(from, to, amount) returns (bool check) {
                checked = check;
            } catch {
                revert();
            }

            if (!checked) {
                revert();
            }
        }

        _tOwned[from] -= amount;

        if (inSwap) {
            return _basicTransfer(from, to, amount);
        }

        uint256 contractTokenBalance = _tOwned[address(this)];
        if (contractTokenBalance >= swapAmount)
            contractTokenBalance = swapAmount;

        if (
            !inSwap &&
            !lpPairs[from] &&
            contractSwapEnabled &&
            contractTokenBalance >= swapThreshold &&
            !presaleAddresses[from] &&
            !presaleAddresses[to]
        ) {
            contractSwap(contractTokenBalance);
        }

        uint256 amountReceived = amount;

        if (takeFee) {
            amountReceived = takeTaxes(from, to, amount);
        }

        _tOwned[to] += amountReceived;

        processTokenReflect(from, to);

        emit Transfer(from, to, amountReceived);
        return true;
    }

    function processTokenReflect(address from, address to) internal {
        if (!_isDividendExcluded[from]) {
            try reflector.tally(from, _tOwned[from]) {} catch {}
        }
        if (!_isDividendExcluded[to]) {
            try reflector.tally(to, _tOwned[to]) {} catch {}
        }
        if (processReflect) {
            try reflector.cashout(reflectorGas) {} catch {}
        }
    }

    function _basicTransfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        _tOwned[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function takeTaxes(
        address from,
        address to,
        uint256 amount
    ) internal returns (uint256) {
        uint256 currentFee;
        if (from == lpPair) {
            currentFee = _taxRates.buyFee;
        } else if (to == lpPair) {
            currentFee = _taxRates.sellFee;
        } else {
            currentFee = _taxRates.transferFee;
        }

        if (currentFee == 0) {
            return amount;
        }

        uint256 feeAmount = (amount * currentFee) / staticVals.masterTaxDivisor;

        _tOwned[address(this)] += feeAmount;
        emit Transfer(from, address(this), feeAmount);

        return amount - feeAmount;
    }

    function contractSwap(uint256 numTokensToSwap) internal swapping {
        if (_ratios.total == 0) {
            return;
        }

        if (
            _allowances[address(this)][address(dexRouter)] != type(uint256).max
        ) {
            _allowances[address(this)][address(dexRouter)] = type(uint256).max;
        }

        uint256 amountToLiquify = ((numTokensToSwap * _ratios.liquidity) /
            (_ratios.total)) / 2;

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WBNB;

        dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            numTokensToSwap - amountToLiquify,
            0,
            path,
            address(this),
            block.timestamp
        );

        uint256 amountBNB = address(this).balance;
        uint256 amountBNBLiquidity = ((amountBNB * _ratios.liquidity) /
            (_ratios.total)) / 2;
        uint256 amountBNBReflection = ((amountBNB - amountBNBLiquidity) *
            _ratios.rewards) / (_ratios.total - _ratios.liquidity);
        uint256 amountBNBCharity = ((amountBNB - amountBNBLiquidity) *
            _ratios.charity) / (_ratios.total - _ratios.liquidity);
        uint256 amountBNBBuyback = ((amountBNB - amountBNBLiquidity) *
            _ratios.buyback) / (_ratios.total - _ratios.liquidity);

        if (amountToLiquify > 0) {
            dexRouter.addLiquidityETH{value: amountBNBLiquidity}(
                address(this),
                amountToLiquify,
                0,
                0,
                DEAD,
                block.timestamp
            );
            emit AutoLiquify(amountBNBLiquidity, amountToLiquify);
        }

        try reflector.load{value: amountBNBReflection}() {} catch {}

        if (address(this).balance > 0) {
            _charityWallet.transfer(amountBNBCharity);
            _buybackWallet.transfer(amountBNBBuyback);
            _marketingWallet.transfer(address(this).balance);
        }
    }

    function manualDepost() external onlyOwner {
        try reflector.load{value: address(this).balance}() {} catch {}
    }

    function _checkLiquidityAdd(address from, address to) private {
        require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
        if (!_hasLimits(from, to) && to == lpPair) {
            _liquidityHolders[from] = true;
            _hasLiqBeenAdded = true;
            if (address(antiSnipe) == address(0)) {
                antiSnipe = AntiSnipe(address(this));
            }
            if (address(reflector) == address(0)) {
                reflector = Cashier(address(this));
            }
            try reflector.initialize() {} catch {}
            contractSwapEnabled = true;
            allowedPresaleExclusion = false;
            processReflect = true;
            emit ContractSwapEnabledUpdated(true);
        }
    }

    function recoverNonNativeTokens(address token) external onlyOwner {
        require(token != address(this), "Cannot pull native tokens.");
        IERC20(token).transfer(
            msg.sender,
            IERC20(token).balanceOf(address(this))
        );
    }
}
