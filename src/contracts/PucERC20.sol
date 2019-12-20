pragma solidity >=0.5.0 <0.6.0;

contract PucERC20 {

    string public constant name = "PUC ERC-20";
    string public constant symbol = "PUCERC20";
    uint8 public constant decimals = 18;
    uint256 public constant token_price = 1e14 wei;

    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
    event Transfer(address indexed from, address indexed to, uint256 tokens);

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_;
    uint256 public amount_eth;
    address payable owner;

    using SafeMath for uint256;

    constructor(uint256 total) public {
	    totalSupply_ = total;
	    owner = msg.sender;
	    balances[owner] = totalSupply_;
        amount_eth = 0;
    }

    function totalSupply() public view returns (uint256) {
	      return totalSupply_;
    }

    function balanceOf(address tokenOwner) public view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public returns (bool) {
        require(numTokens <= balances[msg.sender], "Número de tokens excede o saldo disponível.");

        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address _owner, address _delegate) public view returns (uint256) {
        return allowed[_owner][_delegate];
    }

    function transferFrom(address _owner, address _buyer, uint256 numTokens) public returns (bool) {
        require(numTokens <= balances[_owner], "Número de tokens excede o saldo disponível.");
        require(numTokens <= allowed[_owner][msg.sender], "Número de tokens excede o valor permitido.");

        balances[_owner] = balances[_owner].sub(numTokens);
        allowed[_owner][msg.sender] = allowed[_owner][msg.sender].sub(numTokens);
        balances[_buyer] = balances[_buyer].add(numTokens);
        emit Transfer(_owner, _buyer, numTokens);
        return true;
    }

    function buy() public payable {
        require(msg.value > 0, "O valor deve ser maior que zero.");
        require(msg.value.div(1 wei) % token_price == 0, "Valor deve ser de multiplos do preco do token 1e14 wei.");

        uint256 tokens = msg.value / token_price;

        require(balances[owner] > tokens, "Quantidade de tokens indisponível.");

        amount_eth += msg.value;

        balances[owner] -= tokens;
        balances[msg.sender] += tokens;

        emit Transfer(owner, msg.sender, tokens);
    }

    function getOwner() public view returns (address) {
        return owner;
    }
}

library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b > 0);
        uint256 c = a / b;
        return c;
    }
}
