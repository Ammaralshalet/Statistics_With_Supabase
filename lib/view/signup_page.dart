import 'package:flutter/material.dart';
import 'package:homework/view/form_page.dart';
import 'package:homework/view/signin_page.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  String? selectedEducation;
  String? selectedGender;
  String? selectedMaritalStatus;
  String? selectedCountry;
  String? hasChronicDiseases;
  int? numberOfChildren;
  String? passwordError;
  String? fullNameError;
  String? educationError;
  String? genderError;
  String? maritalStatusError;
  String? countryError;
  String? dateError;
  String? weightError;
  String? heightError;

  final List<String> educationLevels = [
    'لايوجد',
    'إعدادي',
    'ثانوي',
    'جامعي',
    'ماجستير',
    'دكتوراه'
  ];

  final List<String> genders = [
    'ذكر',
    'أنثى',
  ];

  final List<String> maritalStatusesMale = [
    'متزوج',
    'عازب',
    'مطلق',
    'أرمل',
  ];

  final List<String> maritalStatusesFemale = [
    'متزوجة',
    'عزباء',
    'مطلقة',
    'أرملة',
  ];

  final List<String> countries = [
    'دمشق',
    'ريف دمشق',
    'حمص',
    'حلب',
    'درعا',
    'السويداء'
  ];

  final List<String> chronicDiseasesOptions = [
    'سكري',
    'قلب',
    'ضغط',
    'التهاب المفاصل'
  ];

  List<String> get maritalStatuses {
    return selectedGender == 'ذكر'
        ? maritalStatusesMale
        : maritalStatusesFemale;
  }

  final List<String> selectedChronicDiseases = [];

  Future<void> signup() async {
    numberOfChildren = numberOfChildren ?? 0;

    final response = await Supabase.instance.client
        .from('users')
        .insert(
          {
            'name': fullNameController.text,
            'education': selectedEducation,
            'gender': selectedGender,
            'marital_status': selectedMaritalStatus,
            'number_of_children': numberOfChildren,
            'country': selectedCountry,
            'date_of_birth': dateController.text,
            'weight': weightController.text,
            'height': heightController.text,
            'password': passwordController.text,
            'chronic_diseases': hasChronicDiseases,
            'diseases': selectedChronicDiseases.join(', '),
          },
        )
        .select()
        .single();

    if (response.containsKey('id')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FormPage(),
        ),
      );
    } else if (response.containsKey('error')) {
      print('Error inserting data: ${response['error']}');
    } else {
      print('Unexpected response format: $response');
    }
  }

  void validateAndSignup() {
    setState(
      () {
        fullNameError = null;
        educationError = null;
        genderError = null;
        maritalStatusError = null;
        countryError = null;
        dateError = null;
        weightError = null;
        heightError = null;
        passwordError = null;

        if (fullNameController.text.isEmpty) {
          fullNameError = 'هذا الحقل مطلوب';
        }
        if (selectedEducation == null) {
          educationError = 'هذا الحقل مطلوب';
        }
        if (selectedGender == null) {
          genderError = 'هذا الحقل مطلوب';
        }
        if (selectedMaritalStatus == null) {
          maritalStatusError = 'هذا الحقل مطلوب';
        }
        if (selectedCountry == null) {
          countryError = 'هذا الحقل مطلوب';
        }
        if (dateController.text.isEmpty) {
          dateError = 'هذا الحقل مطلوب';
        }
        if (weightController.text.isEmpty) {
          weightError = 'هذا الحقل مطلوب';
        }
        if (heightController.text.isEmpty) {
          heightError = 'هذا الحقل مطلوب';
        }
        if (passwordController.text.isEmpty) {
          passwordError = 'هذا الحقل مطلوب';
        } else if (passwordController.text != confirmPasswordController.text) {
          passwordError = 'تأكد من كلمة السر';
        }

        if (fullNameError == null &&
            educationError == null &&
            genderError == null &&
            maritalStatusError == null &&
            countryError == null &&
            dateError == null &&
            weightError == null &&
            heightError == null &&
            passwordError == null) {
          signup();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffB81736),
                  Color(0xff281537),
                ],
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 15, left: 20),
              child: Text(
                'Create Your\nAccount',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 110.0),
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 18, right: 18, bottom: 18, top: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextField(
                        controller: fullNameController,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                          label: const Text(
                            'Full Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          ),
                          errorText: fullNameError,
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedEducation,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.school,
                            color: Colors.grey,
                          ),
                          label: const Text(
                            'Education',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          ),
                          errorText: educationError,
                        ),
                        items: educationLevels.map(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                        onChanged: (newValue) {
                          setState(
                            () {
                              selectedEducation = newValue;
                            },
                          );
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedGender,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.person_outline,
                            color: Colors.grey,
                          ),
                          label: const Text(
                            'Gender',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          ),
                          errorText: genderError,
                        ),
                        items: genders.map(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                        onChanged: (newValue) {
                          setState(
                            () {
                              selectedGender = newValue;
                              selectedMaritalStatus = null;
                            },
                          );
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedMaritalStatus,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.person_outline,
                            color: Colors.grey,
                          ),
                          label: const Text(
                            'Marital Status',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          ),
                          errorText: maritalStatusError,
                        ),
                        items: maritalStatuses.map(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                        onChanged: (newValue) {
                          setState(
                            () {
                              selectedMaritalStatus = newValue;
                            },
                          );
                        },
                      ),
                      if (selectedMaritalStatus == 'متزوج' ||
                          selectedMaritalStatus == 'مطلق' ||
                          selectedMaritalStatus == 'أرمل' ||
                          selectedMaritalStatus == 'مطلقة' ||
                          selectedMaritalStatus == 'أرملة' ||
                          selectedMaritalStatus == 'متزوجة')
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: DropdownButtonFormField<int>(
                            value: numberOfChildren,
                            items: List.generate(
                                16,
                                (index) => DropdownMenuItem<int>(
                                      value: index,
                                      child: Text(
                                        index.toString(),
                                      ),
                                    )).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                numberOfChildren = newValue;
                              });
                            },
                            decoration: const InputDecoration(
                              suffixIcon: Icon(
                                Icons.child_friendly,
                                color: Colors.grey,
                              ),
                              label: Text(
                                'Number of Children',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffB81736),
                                ),
                              ),
                            ),
                          ),
                        ),
                      DropdownButtonFormField<String>(
                        value: selectedCountry,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                          ),
                          label: const Text(
                            'Country',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          ),
                          errorText: countryError,
                        ),
                        items: countries.map(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                        onChanged: (newValue) {
                          setState(
                            () {
                              selectedCountry = newValue;
                            },
                          );
                        },
                      ),
                      TextField(
                        controller: dateController,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            color: Colors.grey,
                          ),
                          label: const Text(
                            'Date of Birth',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          ),
                          errorText: dateError,
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(
                              () {
                                dateController.text = formattedDate;
                              },
                            );
                          }
                        },
                      ),
                      TextField(
                        controller: weightController,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.line_weight,
                            color: Colors.grey,
                          ),
                          label: const Text(
                            'Weight (kg)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          ),
                          errorText: weightError,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: heightController,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.height,
                            color: Colors.grey,
                          ),
                          label: const Text(
                            'Height (cm)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          ),
                          errorText: heightError,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      DropdownButtonFormField<String>(
                        value: hasChronicDiseases,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.local_hospital,
                            color: Colors.grey,
                          ),
                          label: Text(
                            'Do you have chronic diseases?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          ),
                        ),
                        items: ['نعم', 'لا'].map(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                        onChanged: (newValue) {
                          setState(
                            () {
                              hasChronicDiseases = newValue;
                              if (hasChronicDiseases == 'لا') {
                                selectedChronicDiseases.clear();
                              }
                            },
                          );
                        },
                      ),
                      if (hasChronicDiseases == 'نعم')
                        Column(
                          children: chronicDiseasesOptions.map(
                            (String disease) {
                              return CheckboxListTile(
                                title: Text(disease),
                                value:
                                    selectedChronicDiseases.contains(disease),
                                onChanged: (bool? value) {
                                  setState(
                                    () {
                                      if (value == true) {
                                        selectedChronicDiseases.add(disease);
                                      } else {
                                        selectedChronicDiseases.remove(disease);
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          ).toList(),
                        ),
                      TextField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(
                                () {
                                  isPasswordVisible = !isPasswordVisible;
                                },
                              );
                            },
                          ),
                          label: const Text(
                            'Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          ),
                          errorText: passwordError,
                        ),
                      ),
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: !isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(
                                () {
                                  isConfirmPasswordVisible =
                                      !isConfirmPasswordVisible;
                                },
                              );
                            },
                          ),
                          label: const Text(
                            'Confirm Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          ),
                          errorText: passwordError,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: validateAndSignup,
                        child: InkWell(
                          child: Container(
                            height: 50,
                            width: 280,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xffB81736),
                                  Color(0xff281537),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'SIGN UP',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SigninPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
