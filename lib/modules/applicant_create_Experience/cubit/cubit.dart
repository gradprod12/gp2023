import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp2023/models/ExperienceModel.dart';
import 'package:gp2023/modules/applicant_create_Experience/cubit/states.dart';
//import 'package:gp2023/shared/network/end_points.dart';

class ApplicantCreateExperienceCubit
    extends Cubit<ApplicantCreateExperienceStates> {
  var university = "MTI";
  ApplicantCreateExperienceCubit()
      : super(ApplicantCreateExperienceInitialState());

  static ApplicantCreateExperienceCubit get(context) =>
      BlocProvider.of(context);
  void ExperienceCreate(
      {@required String companyName,
      @required String position,
      @required String startDate,
      @required String endDate,
      @required String uId}) {
    ExperienceModel model = ExperienceModel(
        companyName: companyName,
        position: position,
        startDate: startDate,
        endDate: endDate,
        uId: uId);
    saveExperienceData(model);
  }

  void saveExperienceData(ExperienceModel M) {
    FirebaseFirestore.instance
        .collection('Experience')
        .add(M.toMap())
        .then((value) {
      emit(ApplicantCreateExperienceSuccessState(M.uId));
    }).catchError((error) {
      emit(ApplicantCreateExperienceErrorState(error.toString()));
    });
  }

  void changeCityState(String cityOut) {
    university = cityOut;
    emit(ApplicantCreateExperienceChangeCityState());
  }

  void changeNationalityState(String nationalityOut) {
    university = nationalityOut;
    emit(ApplicantCreateExperienceChangeNationalityState());
  }
}
