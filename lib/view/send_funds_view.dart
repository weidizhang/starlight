import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starlight_credits/controller/send_funds_controller.dart';

class SendFundsViewStateful extends StatefulWidget {
  const SendFundsViewStateful({Key? key}) : super(key: key);

  @override
  State<SendFundsViewStateful> createState() => SendFundsView();
}

class SendFundsView extends State<SendFundsViewStateful> {
  final SendFundsController controller = SendFundsController();

  @override
  Widget build(BuildContext context) {
    controller.updateContext(context);
    return ListView(
      children: [
        Card(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                  child: Text(
                    'Recipient',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'RobotoSlab',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: TextFormField(
                    controller: controller.recipientController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Username',
                    ),
                  ),
                ),
              ]
          ),
        ),
        Card(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                  child: Text(
                    'Amount (\$)',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'RobotoSlab',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: TextFormField(
                    controller: controller.amountController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: '0.00',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                      TextInputFormatter.withFunction(
                            (oldValue, newValue) => newValue.copyWith(
                          text: newValue.text.replaceAll(',', '.'),
                        ),
                      ),
                    ],
                  ),
                ),
              ]
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(elevation: 2),
            onPressed: controller.handleSendClick,
            child: const Text(
              'Send',
              style: TextStyle(
                fontFamily: 'RobotoSlab',
              ),
            ),
          ),
        ),
      ],
      padding: EdgeInsets.all(10),
    );
  }
}