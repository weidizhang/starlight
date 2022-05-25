import 'package:starlight_credits/controller/base_view_controller.dart';
import 'package:starlight_credits/db/firestore_handler.dart';
import 'package:starlight_credits/util/notification_util.dart';

class ProfileController extends BaseViewController {
  Future<void> handleSignOutClick() async {
    FirestoreHandler fsHandler = await FirestoreHandler.getInstance();
    await fsHandler.getUsersHandler().signOutAuthedUser();

    NotificationUtil.showSuccessSnackBarMessage(context, 'You have been signed out.');
  }
}
