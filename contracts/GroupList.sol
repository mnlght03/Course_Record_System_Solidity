// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.0 <0.9.0;

import "./StudentGroup.sol";

contract GroupList {
  StudentGroup[] public list;
  uint public totalGroups;
  mapping (uint => uint) public groupIdx;

  function groupExists(uint groupId) public view returns (bool) {
    return (list[groupIdx[groupId]].id() == groupId && list[groupIdx[groupId]].exists());
  }

  function addGroup(uint groupId) public {
    require(!groupExists(groupId), "addGroup: Group already exists");
    list.push(new StudentGroup(groupId));
    totalGroups++;
    groupIdx[groupId] = list.length;
  }

  function deleteGroup(uint groupId) public {
    require(groupExists(groupId), "deleteGroup: Group doesn't exist");
    delete list[groupIdx[groupId]];
    delete groupIdx[groupId];
    totalGroups--;
  }

  function addStudent(address student, uint groupId) public {
    require(groupExists(groupId), "addStudent: Group doesn't exist");
    list[groupIdx[groupId]].addStudent(student);
  }

  function deleteStudent(address student, uint groupId) public {
    require(groupExists(groupId), "deleteStudent: Group doesn't exist");
    list[groupIdx[groupId]].deleteStudent(student);
  }

  function setCourseTeacher(uint groupId, uint courseId, address teacher) public {
    require(groupExists(groupId), "setCourseTeacher: Group doesn't exist");
    list[groupIdx[groupId]].setCourseTeacher(courseId, teacher);
  }

  function deleteCourseTeacher(uint groupId, uint courseId) public {
    require(groupExists(groupId), "deletCourseTeacher: Group doesn't exist");
    list[groupIdx[groupId]].deleteCourseTeacher(courseId);
  }
}