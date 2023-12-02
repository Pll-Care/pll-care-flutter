enum ProjectErrorType {
  PROJECT_011('완료된 프로젝트에서는 해당 기능을 사용할 수 없습니다.');

  const ProjectErrorType(this.message);

  final String message;
}
