// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Entrypoint} from "../src/Entrypoint.sol";
import {ImplementationMock} from "./mocks/ImplementationMock.sol";

contract EntrypointTest is Test {
    ImplementationMock impl;

    bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    event Upgraded(address indexed implementation);

    function setUp() public {
        impl = new ImplementationMock();
    }

    function test_RevertIf_ImplementationWithNoCode() public {
        address implEOA = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

        vm.expectRevert(abi.encodeWithSelector(Entrypoint.ERC1967InvalidImplementation.selector, implEOA));
        new Entrypoint(address(implEOA), "");
    }

    function test_ImplementationSlotSetCorrectly_WhenContract() public {
        Entrypoint entrypoint = new Entrypoint(address(impl), "");

        bytes32 implAddress = vm.load(address(entrypoint), _IMPLEMENTATION_SLOT);

        assertEq(address(uint160(uint256(implAddress))), address(impl));
    }

    function test_EmitsUpgradedEvent() public {
        vm.expectEmit(true, true, true, true);
        emit Upgraded(address(impl));
        new Entrypoint(address(impl), "");
    }

    function test_InitializationFunctionCalled(uint256 initTestData) public {
        bytes memory initializeData = abi.encodeWithSignature("initialize(uint256)", initTestData);

        Entrypoint entrypoint = new Entrypoint(address(impl), initializeData);

        assertEq(ImplementationMock(address(entrypoint)).value(), initTestData);
    }

    function test_RevertIf_InitializationReverts(uint256 errorValue) public {
        bytes memory initializeData = abi.encodeWithSignature("initializeWithError(uint256)", errorValue);

        vm.expectRevert(abi.encodeWithSelector(ImplementationMock.CustomError.selector, errorValue));
        new Entrypoint(address(impl), initializeData);
    }

    function test_functionCallIsDelegated(uint256 value) public {
        Entrypoint entrypoint = new Entrypoint(address(impl), "");

        // delegate setValue()
        ImplementationMock(address(entrypoint)).setValue(value);

        // delegate value()
        assertEq(ImplementationMock(address(entrypoint)).value(), value);

        // check directly storage impact
        assertEq(uint256(vm.load(address(entrypoint), 0)), value);
    }

    function test_RevertIf_functionCallReverts(uint256 value) public {
        Entrypoint entrypoint = new Entrypoint(address(impl), "");
        ImplementationMock(address(entrypoint)).setValue(value);

        vm.expectRevert(abi.encodeWithSelector(ImplementationMock.CustomError.selector, value));
        ImplementationMock(address(entrypoint)).revertWithError();
    }
}
