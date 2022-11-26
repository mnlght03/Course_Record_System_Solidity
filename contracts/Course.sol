// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Course {
  string public name;
  uint public id;
  address[] public teacherAddresses;
  uint public totalTeachers;
  // @dev address => idx
  mapping (address => uint) teacherIdx;
  bool deleted;

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

  function exists() public view returns (bool) {
    return !deleted;
  }

  function deleteSelf() public {
    delete name;
    delete id;
    delete totalTeachers;
    for (uint i = 0; i < teacherAddresses.length; i++)
      delete teacherIdx[getTeacherAddress(i)];
    delete teacherAddresses;
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

  function getCourseTeachersIds() public view returns (address[] memory teachers) {
    uint idx = 0;
    for (uint i = 0; i < teacherAddresses.length; i++) {
      if (teacherAddresses[i] != address(0))
        teachers[idx++] = teacherAddresses[i];
    }
  }
}