pragma solidity ^0.8.19;

import "./PuzzleBox.sol";
import "forge-std/Test.sol";

contract CleanPuzzleBoxSolution {

    function solve() external payable {
        // How close can you get to opening the box?
        bytes memory selectoors = hex"7159a6188fd66f250091905511551052925facb1000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000007000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000092b071e47000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000001000000000000000000000000416e59dacfdb5d457304115bbfb9089531d873b70000000000000000000000000000000000000000000000000000000000000003000000000000000000000000c817dd2a5daa8f790677e399170c92aabd044b570000000000000000000000000000000000000000000000000000000000000096000000000000000000000000000000000000000000000000000000000000004b58657dcfc8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d800000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000041c8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d89da3468f3d897010503caed5c52689b959fbac09ff6879275a8279feffcc8a621b00000000000000000000000000000000000000000000000000000000000000";
        // bytes memory helperCode = hex"60c060405273037eda3adb1198021a9b2e88c22b464fd38db3f373ffffffffffffffffffffffffffffffffffffffff1660808173ffffffffffffffffffffffffffffffffffffffff16815250503373ffffffffffffffffffffffffffffffffffffffff1660a08173ffffffffffffffffffffffffffffffffffffffff168152505060805173ffffffffffffffffffffffffffffffffffffffff16637159a6186040518163ffffffff1660e01b8152600401600060405180830381600087803b1580156100ca57600080fd5b505af11580156100de573d6000803e3d6000fd5b5050505073037eda3adb1198021a9b2e88c22b464fd38db3f373ffffffffffffffffffffffffffffffffffffffff1663deecedd463925facb160e01b60006040518363ffffffff1660e01b81526004016101399291906101c6565b600060405180830381600087803b15801561015357600080fd5b505af1158015610167573d6000803e3d6000fd5b505050506101ef565b60007fffffffff0000000000000000000000000000000000000000000000000000000082169050919050565b6101a581610170565b82525050565b60008115159050919050565b6101c0816101ab565b82525050565b60006040820190506101db600083018561019c565b6101e860208301846101b7565b9392505050565b60805160a0516101796102126000396000609e01526000600f01526101796000f3fe6080604052610151471461009c577f000000000000000000000000000000000000000000000000000000000000000073ffffffffffffffffffffffffffffffffffffffff1660656040516100529061012e565b60006040518083038185875af1925050503d806000811461008f576040519150601f19603f3d011682016040523d82523d6000602084013e610094565b606091505b5050506100d5565b7f000000000000000000000000000000000000000000000000000000000000000073ffffffffffffffffffffffffffffffffffffffff16ff5b005b600081905092915050565b7f9f678cca00000000000000000000000000000000000000000000000000000000600082015250565b60006101186004836100d7565b9150610123826100e2565b600482019050919050565b60006101398261010b565b915081905091905056fea26469706673582212208f094eb57682c27f678c08cf065a2df5b481a1c1e9514fcefff5890dd9318c1264736f6c63430008130033";
        bytes memory helperCode = type(Helper).creationCode;
        console.logBytes(helperCode);
        bytes memory helperCode = type(Helper).creationCode;
        // console.logBytes(helperCode);
        // bytes memory helperCalldata = abi.encodePacked(helperCode, abi.encode(_puzzle));
        // console.logBytes(helperCalldata);
        assembly {
            let helperAddr := create(0, add(helperCode, 0x20), mload(helperCode))
            pop(call(gas(), helperAddr, 0, 0, 0, 0, 0))
            // puzzle.leak()
            pop(call(gas(), 0x69209d8a7d258515eC9a4D25F7Be1dB85cB1B826, 0, add(selectoors, 0x24), 4, 0, 0))
            // warming up puzzle + 2 // not needed now as it's been done in Helper's fallback
            // pop(call(gas(), add(_puzzle, 2), 1, 0, 0, 0, 0))
            // zip
            pop(call(gas(), 0x69209d8a7d258515eC9a4D25F7Be1dB85cB1B826, 0, add(selectoors, 0x28), 4, 0, 0))
            // creep
            pop(call(98000, 0x69209d8a7d258515eC9a4D25F7Be1dB85cB1B826, 0, add(selectoors, 0x2c), 4, 0, 0))
            // torch
            pop(call(gas(), 0x69209d8a7d258515eC9a4D25F7Be1dB85cB1B826, 0, add(selectoors, 0x30), 293, 0, 0))
            // spread
            pop(call(gas(), 0x69209d8a7d258515eC9a4D25F7Be1dB85cB1B826, 0, add(selectoors, 0x155), 260, 0, 0))
            // open
            pop(call(gas(), 0x69209d8a7d258515eC9a4D25F7Be1dB85cB1B826, 0, add(selectoors, 0x259), 196, 0, 0))
        }
    }
}


contract Helper {
    constructor() payable {
        // bytes memory data = hex"7159a618deecedd4925facb1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
        // console.logBytes4(bytes4(keccak256("torch(bytes)"))); 
        // console.logBytes(abi.encodeWithSignature("lock(bytes4,bool)", bytes4(keccak256("torch(bytes)")), false));       
        assembly {
            mstore(0x00, hex"7159a618deecedd4925facb10000000000000000000000000000000000000000")
            // operate
            pop(call(gas(), 0x69209d8a7d258515eC9a4D25F7Be1dB85cB1B826, 0, 0x00, 4, 0, 0))
            // lock()
            pop(call(gas(), 0x69209d8a7d258515eC9a4D25F7Be1dB85cB1B826, 0, 0x04, 68, 0, 0))
        }
    }

    fallback() external payable {
        assembly {
            switch eq(selfbalance(), 337)
            case 0 {
                mstore(0, hex"9f678cca")
                pop(call(gas(), 0x69209d8a7d258515eC9a4D25F7Be1dB85cB1B826, 101, 0x00, 4, 0, 0))
            }
            case 1 {
                // warming puzzle + 2
                selfdestruct(0x69209d8a7d258515eC9a4D25F7Be1dB85cB1B828)
            }
        }
    }
}


