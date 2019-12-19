var contractAddress = '0xc100084d608ff1f1df70c3d7c850a714d3724e7c'
var provider = new ethers.providers.Web3Provider(web3.currentProvider)
ethereum.enable()

var signer = provider.getSigner()
var contract = new ethers.Contract(contractAddress, abiContract, signer)

function totalSupply() {
	contract.totalSupply().then(function(result) {
		console.log('totalSupply - result', result)
		$('#total').text(result)
	})
}

function symbol() {
	contract.symbol().then(function(result) {
		console.log('symbol - result', result)
		$('#symbol').text(result)
	})
}

function tokenName() {
	contract.name().then(function(result) {
		console.log('name - result', result)
		$('#tokenname').text(result)
	})
}

function decimals() {
	contract.decimals().then(function(result) {
		console.log('decimals - result', result)
		$('#decimals').text(result)
	})
}

function balanceOf() {
	const tokenOwner = $('#tokenowner').val()
	contract.balanceOf(tokenOwner).then(function(result) {
		console.log('balanceOf - result', result)
		$('#balanceof').text(result)
	})
}

function allowance(address, delegate) {
	contract
		.allowance(address, delegate)
		.then(function(transaction) {
			console.log('allowance - transaction', transaction)
			return transaction.wait()
		})
		.then(function(result) {
			console.log('allowance - result', result)
			alert(JSON.stringify(result))
		})
}

function transfer() {
	const receiver = $('#receiver').val()
	const numTokens = $('#numtokens').val()

	contract
		.transfer(receiver, numTokens)
		.then(function(transaction) {
			console.log('transfer - transaction', transaction)
			alert('Sua transferência está sendo processada. Aguarde.')
			return transaction.wait()
		})
		.then(function(result) {
			console.log('transfer - result', result)
			alert('Transferência processada:\n' + JSON.stringify(result))
		})
		.catch(function(error) {
			alert(
				'Erro ao processar transferência:\nVerifique se o valor digitado é múltiplo de 1e14 wei.\n' +
					JSON.stringify(error)
			)
		})
}

function transferFrom(owner, buyer, numTokens) {
	contract
		.transferFrom(owner, buyer, numTokens)
		.then(function(transaction) {
			console.log('transferFrom - transaction', transaction)
			return transaction.wait()
		})
		.then(function(result) {
			console.log('transferFrom - result', result)
			alert(JSON.stringify(result))
		})
}

function approve(delegate, numTokens) {
	contract
		.approve(delegate, numTokens)
		.then(function(transaction) {
			console.log('approve - transaction', transaction)
			return transaction.wait()
		})
		.then(function(result) {
			console.log('approve - result', result)
			alert(JSON.stringify(result))
		})
}
