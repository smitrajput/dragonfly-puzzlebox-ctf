// const Web3 = require("web3");
// const web3 = new Web3("https://eth-mainnet.g.alchemy.com/v2/BKt4FdcCBCJR7b5-KAdqNfoovPA7rFcx"); // replace with your Ethereum node URL

// const desiredAddress = "0x037eDa3aDB1198021A9b2e88C22B464fD38db3f4";
// const deployerAddress = "0x8d2C17FAd02B7bb64139109c6533b7C2b9CADb81"; // replace with the deployed PuzzleBoxSolution contract address
// const contractACreationCode = "0x6080604052348015600f57600080fd5b50604580601d6000396000f3fe608060405236600a57005b600080fdfea26469706673582212203068c347e84e3cf117b00bb69911bec9869520a510052e0bf8358aa33d8319fc64736f6c63430008130033"; // replace with the creation code of contract A

// const findSalt = async () => {
//   const codehash = web3.utils.keccak256(contractACreationCode);

//   for (let i = 0; i < Number.MAX_SAFE_INTEGER; i++) {
//     const salt = web3.utils.numberToHex(i);
//     const computedAddress = web3.utils.toChecksumAddress(
//       "0x" +
//         web3.utils
//           .keccak256(
//             "0xff" +
//               deployerAddress.slice(2) +
//               salt.slice(2) +
//               codehash.slice(2)
//           )
//           .slice(-40)
//     );

//     if (computedAddress === desiredAddress) {
//       console.log(`Found the correct salt: ${salt}`);
//       break;
//     }
//   }
// };

// findSalt();

const ethUtil = require('ethereumjs-util');

const hashedMessage = Buffer.from('c8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d8', 'hex');
const r = Buffer.from('c8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d8', 'hex');
const s = Buffer.from('625cb970c2768fefafc3512a3ad9764560b330dcafe02714654fe48dd069b6df', 'hex');
const v = 28; // Assuming v = 0x1c is equivalent to v = 27

const publicKey = ethUtil.ecrecover(hashedMessage, v, r, s);
const signerAddress = ethUtil.publicToAddress(publicKey).toString('hex');

console.log(`Signer address: 0x${signerAddress}`);
