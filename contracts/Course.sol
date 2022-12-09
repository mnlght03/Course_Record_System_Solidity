// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

contract Course {
  string public name;
  uint public id;
  address[] public teacherAddresses;
  uint public totalTeachers;
  // @dev address => idx
  mapping (address => uint) teacherIdx;
  mapping (uint => bool) public availableForGroup;

  constructor(string memory courseName, uint _id) {
    name = courseName;
    id = _id;
  }

  function getCourseName() public view returns (string memory) {
    return name;
  }

  function getCourseId() public view returns (uint) {
    return id;
  }

  function addTeacher(address teacherAddress) public {
    teacherAddresses.push(teacherAddress);
    teacherIdx[teacherAddress] = teacherAddresses.length - 1;
    totalTeachers++;
  }

  function deleteTeacher(address teacherAddress) public {
    delete teacherAddresses[getTeacherIdx(teacherAddress)];
    delete teacherIdx[teacherAddress];
    totalTeachers--;
  }

  function getTeacherAddress(uint idx) internal view returns (address) {
    return teacherAddresses[idx];
  }

  function getTeacherIdx(address teacherAddress) internal view returns (uint) {
    return teacherIdx[teacherAddress];
  }

  function getCourseTeachers() public view returns (address[] memory teachers) {
    uint idx = 0;
    for (uint i = 0; i < teacherAddresses.length; i++) {
      if (teacherAddresses[i] != address(0))
        teachers[idx++] = teacherAddresses[i];
    }
  }

  function makeAvailableForGroup(uint _groupId) public {
    availableForGroup[_groupId] = true;
  }

  function makeUnavailableForGroup(uint _groupId) public {
    availableForGroup[_groupId] = false;
  }
}