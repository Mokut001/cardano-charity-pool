let walletApi = null;
const scriptAddress = "addr_test1wqxyzplaceholderforcontract..."; // Replace with compiled contract address

async function connectWallet() {
    if (!window.cardano || !window.cardano.cbyox) {
        alert("No CIP-30 wallet found!");
        return;
    }
    try {
        walletApi = await window.cardano.cbyox.enable();
        const addr = await walletApi.getUsedAddresses();
        document.getElementById("status").innerText = "Wallet connected: " + addr[0].slice(0,20) + "...";
        console.log("Connected address:", addr);
    } catch (err) {
        console.error(err);
        document.getElementById("status").innerText = "Wallet connection failed!";
    }
}

async function deposit() {
    if (!walletApi) { alert("Connect wallet first!"); return; }
    const amountADA = parseFloat(document.getElementById("depositAmount").value);
    if (!amountADA || amountADA <= 0) { alert("Enter a valid ADA amount"); return; }
    try {
        const lovelaceAmount = BigInt(amountADA * 1000000);
        const tx = await walletApi.buildTransaction({
            outputs: [{ address: scriptAddress, amount: [{ unit: "lovelace", quantity: lovelaceAmount.toString() }] }]
        });
        const signedTx = await walletApi.signTx(tx);
        const txHash = await walletApi.submitTx(signedTx);
        document.getElementById("txStatus").innerText = "Deposit successful! TxHash: " + txHash;
    } catch (err) {
        console.error(err);
        document.getElementById("txStatus").innerText = "Deposit failed: " + err.message;
    }
}

async function withdraw() {
    if (!walletApi) { alert("Connect wallet first!"); return; }
    try {
        const tx = await walletApi.buildTransaction({
            outputs: [{ address: (await walletApi.getUsedAddresses())[0], amount: [{ unit: "lovelace", quantity: "1000000" }] }]
        });
        const signedTx = await walletApi.signTx(tx);
        const txHash = await walletApi.submitTx(signedTx);
        document.getElementById("txStatus").innerText = "Withdraw successful! TxHash: " + txHash;
    } catch (err) {
        console.error(err);
        document.getElementById("txStatus").innerText = "Withdraw failed: " + err.message;
    }
}

document.getElementById("connectWalletBtn").onclick = connectWallet;
document.getElementById("depositBtn").onclick = deposit;
document.getElementById("withdrawBtn").onclick = withdraw;