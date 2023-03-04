import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:gp2023/modules/applicant_home_module/cubit/cubit.dart';
import 'package:gp2023/shared/jobs.dart';

import '../../models/JobSearch.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/styles/colors.dart';
import '../filter_module/filterHome.dart';

class ApplicantHome extends StatefulWidget {
  const ApplicantHome({Key key}) : super(key: key);

  @override
  State<ApplicantHome> createState() => _ApplicantHomeState();
}

class _ApplicantHomeState extends State<ApplicantHome> {

  @override
  Widget build(BuildContext context) {
    var body = new Container(child:ApplicantRegisterCubit.get(context).listofJobs);
    ApplicantRegisterCubit.get(context).searchList ??
        (ApplicantRegisterCubit.get(context).searchList = jobList);
    ApplicantRegisterCubit.get(context).jobsCount ??           //      get jobs here
        (ApplicantRegisterCubit.get(context).jobsCount = jobList.length);
    return ConditionalBuilder(
      condition: ApplicantRegisterCubit.get(context).searchList != null,
      builder: (context) {
        var searchController = TextEditingController();
        return CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 160.0,
            backgroundColor: Color(0xff1B75BC),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50))),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Padding(
                  child: Row(children: [
                    Text('Hi, ${CacheHelper.getData(key: 'name')} !'),
                  ], crossAxisAlignment: CrossAxisAlignment.center),
                  padding: EdgeInsets.only(left: 10, right: 5, top: 20,bottom: 10)),
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(top: 10)),
          SliverToBoxAdapter(
              child: defaultFormField(
                  type: TextInputType.emailAddress,
                  label: 'Search',
                  prefix: Icons.search,
                  suffix: Icons.sort,
                  suffixPressed: () {
                    navigateTo(context, FilterHome());
                  },
                  onChange: (value) {
                    ApplicantRegisterCubit.get(context).changeListSearch(value, context);
                    setState(() {
                      ApplicantRegisterCubit.get(context).listofJobs;
                    });
                  })),
          SliverPadding(
              padding: EdgeInsets.only(top: 10),
              sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                GestureDetector(
                  onTap: () {},
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Image(
                            image: NetworkImage(
                                'https://cdn.searchenginejournal.com/wp-content/uploads/2017/06/shutterstock_268688447-760x400.webp'),
                          ),
                          Divider(),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              "${ApplicantRegisterCubit.get(context).searchList[index].jobTitle}(${ApplicantRegisterCubit.get(context).searchList[index].salary} EGP)",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start),
                          Text(
                              "As ${ApplicantRegisterCubit.get(context).searchList[index].role} starting from ${ApplicantRegisterCubit.get(context).searchList[index].startDate})",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              "Job type: ${ApplicantRegisterCubit.get(context).searchList[index].role}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                              child: SizedBox(
                            width: double.infinity / 2,
                            child: Text(
                                "${ApplicantRegisterCubit.get(context).searchList[index].description}"),
                          )),
                          Text('Recommended Jobs')
                        ],
                      ),
                    ),
                  ),
                );
              }))),
          SliverToBoxAdapter (child:body ),
        ]);
      },
      fallback: (context) {
        Center(child: CircularProgressIndicator());
      },
    );
  }

}
