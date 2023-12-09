package com.example.kalmiagram_flutter;

import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.BinaryMessenger;

public class MainActivity extends FlutterActivity {

    private static final String KALMIAGRAM_METHOD_CHANNLE = "kalmiagram_method_channel";
    private MethodChannel methodChannel;
    private static final String KALMIAGRAM_EVENT_CHANNLE = "kalmiagram_event_channel";
    private EventChannel.EventSink eventChannel;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), KALMIAGRAM_METHOD_CHANNLE);
        // 接受 Flutter 端传递过来的方法，并做出响应逻辑处理
        methodChannel
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("sendDataToJava")) {
                        // call.arguments: 从 Flutter 收到的数据
                        Log.d("debug", call.arguments.toString());
                        // result.success()，返回数据给 Flutter
                        // 一次会话通道只能回复一次
                        result.success("Hello from Java!");
                    } else if (call.method.equals("sendDataToFlutter")) {
                        nativeSendMessage2Flutter();
                        result.success("success");
                    }
                });

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), KALMIAGRAM_EVENT_CHANNLE).setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object o, EventChannel.EventSink eventSink) {
                eventChannel = eventSink;
                eventSink.success("事件通道准备就绪");
            }

            @Override
            public void onCancel(Object o) {

            }
        });
    }

    private void nativeSendMessage2Flutter() {
        eventChannel.success("原生端向flutter主动发送消息");
    }
}
