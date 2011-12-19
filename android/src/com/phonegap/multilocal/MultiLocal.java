package com.phonegap.multilocal;

import android.app.Activity;
import android.os.Bundle;
import android.view.WindowManager;

import com.phonegap.*;

public class MultiLocal extends DroidGap
{
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        super.loadUrl("file:///android_asset/www/index.html");

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, 
                            WindowManager.LayoutParams.FLAG_FULLSCREEN | 
                            WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN);

    }
}

