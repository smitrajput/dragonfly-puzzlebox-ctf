// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/PuzzleBox.sol";
import "../src/CleanPuzzleBoxSolution.sol";

contract PuzzleBoxFixture is Test {
    event Lock(bytes4 selector, bool isLocked);
    event Operate(address operator);
    event Drip(uint256 dripId, uint256 fee);
    event Spread(uint256 amount, uint256 remaining);
    event Zip();
    event Creep();
    event Torch(uint256[] dripIds);
    event Burned(uint256 dripId);
    event Open(address winner);

    PuzzleBoxFactory _factory = new PuzzleBoxFactory();
    PuzzleBox _puzzle;
    CleanPuzzleBoxSolution _solution;
    // address deployer;

    // Use a modifier instead of setUp() to keep it all in one tx.
    modifier initEnv() {
        // deployer = vm.addr(0xcc7ec7a48ef9945cd647aa5c01a0dc8967612dd70c0a24f7bfb53e29a04f04fe);
        // vm.deal(deployer, 1 ether);
        // vm.startPrank(deployer);
        _puzzle = _factory.createPuzzleBox{value: 1337}();
        _solution = CleanPuzzleBoxSolution(address(new SolutionContainer(type(CleanPuzzleBoxSolution).runtimeCode)));
        _;
    }

    function test_win() external initEnv {
        // Uncomment to verify a complete solution.
        // vm.expectEmit(false, false, false, false, address(_puzzle));
        // emit Open(address(0));
        // console.log("PUZZZZZLE", address(_puzzle));
        // vm.breakpoint("b");
        uint256 gas = gasleft();
        _solution.solve(_puzzle);
        console.log("GAS USED", gas - gasleft());
        // address(_solution).call(abi.encodeWithSignature("solve()", _puzzle));
    }
}


contract SolutionContainer {
    constructor(bytes memory solutionRuntime) {
        assembly {
            return(add(solutionRuntime, 0x20), mload(solutionRuntime))
        }
    }
}
