package cn.waitwalker.badge_manager;
import android.annotation.SuppressLint;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.AsyncQueryHandler;
import android.content.ComponentName;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.service.notification.StatusBarNotification;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

/// 设置角标工具类
public class BadgeTools {

    /// 推送id
    private static int notificationId = 0;

    /// methodName isSupported
    /// description 是否支持
    /// date 2022/4/15 16:58
    /// author waitwalker
    public static boolean isSupported() {
        switch (Build.BRAND.toLowerCase()) {
            case "xiaomi":
            case "huawei":
            case "honor":
            case "samsung":
            case "lenovo":
            case "htc":
            case "sony":
                return true;
            default:
                return false;
        }
    }

    /// methodName getBrand
    /// description 获取手机品牌
    /// date 2022/4/15 16:58
    /// author waitwalker
    public static String getBrand() {
        return Build.BRAND.toLowerCase();
    }

    /// methodName setCount
    /// description 设置角标
    /// date 2022/4/15 16:58
    /// author waitwalker
    public static void setCount(final int count, final Context context, Class cls, String title, String content) {
        if (!isSupported()) return;
        if (count >= 0 && context != null) {
            switch (Build.BRAND.toLowerCase()) {
                case "xiaomi":
                    setNotificationBadge(count, context, cls, title, content);
                    return;
                case "huawei":
                case "honor":
                    setHuaweiBadge(count, context);
                    return;
                case "samsung":
                    setNotificationBadge(count, context, cls, title, content);
                    setSamsungBadge(count, context);
                    return;
                case "oppo":
                    setNotificationBadge(count, context, cls, title, content);
                    if (!setOPPOBadge(count, context)) {
                        setOPPOBadge2(count, context);
                    }
                    return;
                case "vivo":
                    setNotificationBadge(count, context, cls, title, content);
                    setViVoBadge(count, context);
                    return;
                case "lenovo":
                    setZukBadge(count, context);
                    return;
                case "htc":
                    setHTCBadge(count, context);
                    return;
                case "sony":
                    setSonyBadge(count, context);
                    return;
                default:
                    setNotificationBadge(count, context, cls, title, content);
            }
        } else {

        }
    }

    public static void setNotificationBadge(int count, final Context context, final Class cls, String title, String content) {
        NotificationManager notificationManager = (NotificationManager) context.getSystemService
                (Context.NOTIFICATION_SERVICE);
        if (notificationManager == null) {
            return;
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // 8.0之后添加角标需要NotificationChannel
            NotificationChannel channel = new NotificationChannel("badge", "badge",
                    NotificationManager.IMPORTANCE_DEFAULT);
            channel.setShowBadge(true);
            notificationManager.createNotificationChannel(channel);
        }
        Intent intent = new Intent(context, cls);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, 0);
        Notification notification = new NotificationCompat.Builder(context, "badge")
                .setContentTitle(title)
                .setContentText(content)
                .setLargeIcon(BitmapFactory.decodeResource(context.getResources(), R.drawable
                        .pushpin))
                .setSmallIcon(R.drawable.pushpin)
                .setAutoCancel(true)
                .setContentIntent(pendingIntent)
                .setChannelId("badge")
                .setNumber(count)
                .setBadgeIconType(NotificationCompat.BADGE_ICON_SMALL).build();
        // 小米
        if (Build.BRAND.equalsIgnoreCase("xiaomi")) {
            setXiaomiBadge(count, notification);
        }
        notificationManager.notify(notificationId++, notification);
    }

    private static void setXiaomiBadge(int count, Notification notification) {
        try {
            Field field = notification.getClass().getDeclaredField("extraNotification");
            Object extraNotification = field.get(notification);
            Method method = extraNotification.getClass().getDeclaredMethod("setMessageCount", int
                    .class);
            method.invoke(extraNotification, count);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void setHuaweiBadge(int count, Context context) {
        try {
            String launchClassName = getLauncherClassName(context);
            if (TextUtils.isEmpty(launchClassName)) {
                return;
            }
            Bundle bundle = new Bundle();
            bundle.putString("package", context.getPackageName());
            bundle.putString("class", launchClassName);
            bundle.putInt("badgenumber", count);
            context.getContentResolver().call(Uri.parse("content://com.huawei.android.launcher" +
                    ".settings/badge/"), "change_badge", null, bundle);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void setSamsungBadge(int count, Context context) {
        try {
            String launcherClassName = getLauncherClassName(context);
            if (TextUtils.isEmpty(launcherClassName)) {
                return;
            }
            Intent intent = new Intent("android.intent.action.BADGE_COUNT_UPDATE");
            intent.putExtra("badge_count", count);
            intent.putExtra("badge_count_package_name", context.getPackageName());
            intent.putExtra("badge_count_class_name", launcherClassName);
            context.sendBroadcast(intent);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Deprecated
    private static boolean setOPPOBadge(int count, Context context) {
        try {
            Bundle extras = new Bundle();
            extras.putInt("app_badge_count", count);
            context.getContentResolver().call(Uri.parse("content://com.android.badge/badge"),
                    "setAppBadgeCount", String.valueOf(count), extras);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Deprecated
    private static boolean setOPPOBadge2(int count, Context context) {
        try {
            Intent intent = new Intent("com.oppo.unsettledevent");
            intent.putExtra("packageName", context.getPackageName());
            intent.putExtra("number", count);
            intent.putExtra("upgradeNumber", count);
            PackageManager packageManager = context.getPackageManager();
            List<ResolveInfo> receivers = packageManager.queryBroadcastReceivers(intent, 0);
            if (receivers != null && receivers.size() > 0) {
                context.sendBroadcast(intent);
            } else {
                Bundle extras = new Bundle();
                extras.putInt("app_badge_count", count);
                context.getContentResolver().call(Uri.parse("content://com.android.badge/badge"),
                        "setAppBadgeCount", null, extras);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @SuppressLint("WrongConstant")
    @Deprecated
    private static boolean setViVoBadge(int count, Context context) {
        try {
            String launcherClassName = getLauncherClassName(context);
            if (TextUtils.isEmpty(launcherClassName)) {
                return false;
            }
            Intent intent = new Intent();
            intent.setAction("launcher.action.CHANGE_APPLICATION_NOTIFICATION_NUM");
            intent.addFlags(0x01000000);
            intent.putExtra("packageName", context.getPackageName());
            intent.putExtra("className", launcherClassName);
            intent.putExtra("notificationNum", count);
            context.sendBroadcast(intent);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private static void setZukBadge(int count, Context context) {
        try {
            Bundle extra = new Bundle();
            ArrayList<String> ids = new ArrayList<>();
            extra.putStringArrayList("app_shortcut_custom_id", ids);
            extra.putInt("app_badge_count", count);
            Uri contentUri = Uri.parse("content://com.android.badge/badge");
            Bundle bundle = context.getContentResolver().call(contentUri, "setAppBadgeCount", null,
                    extra);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void setHTCBadge(int count, Context context) {
        try {
            ComponentName launcherComponentName = getLauncherComponentName(context);
            if (launcherComponentName == null) {
                return;
            }

            Intent intent1 = new Intent("com.htc.launcher.action.SET_NOTIFICATION");
            intent1.putExtra("com.htc.launcher.extra.COMPONENT", launcherComponentName
                    .flattenToShortString());
            intent1.putExtra("com.htc.launcher.extra.COUNT", count);
            context.sendBroadcast(intent1);

            Intent intent2 = new Intent("com.htc.launcher.action.UPDATE_SHORTCUT");
            intent2.putExtra("packagename", launcherComponentName.getPackageName());
            intent2.putExtra("count", count);
            context.sendBroadcast(intent2);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void setSonyBadge(int count, Context context) {
        String launcherClassName = getLauncherClassName(context);
        if (TextUtils.isEmpty(launcherClassName)) {
            return;
        }
        try {
            //官方给出方法
            ContentValues contentValues = new ContentValues();
            contentValues.put("badge_count", count);
            contentValues.put("package_name", context.getPackageName());
            contentValues.put("activity_name", launcherClassName);
            SonyAsyncQueryHandler asyncQueryHandler = new SonyAsyncQueryHandler(context
                    .getContentResolver());
            asyncQueryHandler.startInsert(0, null, Uri.parse("content://com.sonymobile.home" +
                    ".resourceprovider/badge"), contentValues);
        } catch (Exception e) {
            try {
                //网上大部分使用方法
                Intent intent = new Intent("com.sonyericsson.home.action.UPDATE_BADGE");
                intent.putExtra("com.sonyericsson.home.intent.extra.badge.SHOW_MESSAGE", count > 0);
                intent.putExtra("com.sonyericsson.home.intent.extra.badge.ACTIVITY_NAME",
                        launcherClassName);
                intent.putExtra("com.sonyericsson.home.intent.extra.badge.MESSAGE", String
                        .valueOf(count));
                intent.putExtra("com.sonyericsson.home.intent.extra.badge.PACKAGE_NAME", context
                        .getPackageName());
                context.sendBroadcast(intent);
            } catch (Exception e1) {
                e1.printStackTrace();
            }
        }
    }

    /// methodName removeBadge
    /// description 移除角标
    /// date 2022/4/15 16:59
    /// author waitwalker
    @RequiresApi(api = Build.VERSION_CODES.M)
    public static void removeBadge(final Context context) {
        if (!isSupported()) return;
        switch (Build.BRAND.toLowerCase()) {
            case "xiaomi":
            case "samsung":
            case "oppo":
                cancelNotification(context, Build.BRAND.toLowerCase());
                return;
            case "huawei":
            case "honor":
                setHuaweiBadge(0, context);
                return;
            case "vivo":
                //setVivoBadge(count, context);
                return;
            case "lenovo":
                //setZukBadge(count, context);
                return;
            case "htc":
                //setHTCBadge(count, context);
                return;
            case "sony":
                //setSonyBadge(count, context);
                return;
            default:
                return;
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    private static void cancelNotification(final Context context, String brand) {
        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        if (brand.equals("xiaomi")) {
            notificationManager.cancelAll();
        } else {
            StatusBarNotification[] activeNotifications = notificationManager.getActiveNotifications();
            if (activeNotifications.length != 0) {
                for (StatusBarNotification activeNotification : activeNotifications) {
                    //根据渠道id取消同一渠道id下的所有通知
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        Log.i("1",activeNotification.getNotification().getChannelId());
                        if (activeNotification.getNotification().getChannelId().equals("badge")) {
                            notificationManager.cancel(activeNotification.getId());
                        }
                    }
                }
            }
        }
    }

    private static String getLauncherClassName(Context context) {
        ComponentName launchComponent = getLauncherComponentName(context);
        if (launchComponent == null) {
            return "";
        } else {
            return launchComponent.getClassName();
        }
    }

    private static ComponentName getLauncherComponentName(Context context) {
        Intent launchIntent = context.getPackageManager().getLaunchIntentForPackage(context
                .getPackageName());
        if (launchIntent != null) {
            return launchIntent.getComponent();
        } else {
            return null;
        }
    }

    static class SonyAsyncQueryHandler extends AsyncQueryHandler {
        SonyAsyncQueryHandler(ContentResolver cr) {
            super(cr);
        }
    }
}
