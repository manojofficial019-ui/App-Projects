package com.aura.financetracker;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.MobileAds;


import androidx.appcompat.app.ActionBarDrawerToggle;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.core.view.GravityCompat;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.aura.financetracker.adapter.ExpenseAdapter;
import com.google.android.material.navigation.NavigationView;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;

public class MainActivity extends AppCompatActivity {

    private DrawerLayout drawerLayout;
    private EditText inputTitle, inputAmount;
    private TextView totalText;

    private ExpenseAdapter adapter;
    private ExpenseDao expenseDao;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Initialize the Mobile Ads SDK
        try {
            MobileAds.initialize(this, initializationStatus -> {});
            
            // Find the AdView and load an ad
            AdView adView = findViewById(R.id.adView);
            if (adView != null) {
                AdRequest adRequest = new AdRequest.Builder().build();
                adView.loadAd(adRequest);
            }
        } catch (Exception e) {
            // Ads initialization failed, continue without ads
            Log.e("MainActivity", "Ads initialization failed", e);
        }

        // Initialize database
        AppDatabase db = AppDatabase.getInstance(this);
        expenseDao = db.expenseDao();

        // SharedPreferences to track last resets
        SharedPreferences weeklyPrefs = getSharedPreferences("WeeklyData", MODE_PRIVATE);
        SharedPreferences monthlyPrefs = getSharedPreferences("MonthlyData", MODE_PRIVATE);

        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
        String todayStr = sdf.format(cal.getTime());

        int currentWeek = cal.get(Calendar.WEEK_OF_YEAR);
        int currentMonth = cal.get(Calendar.MONTH);

        int lastWeek = weeklyPrefs.getInt("lastWeekOfYear", -1);
        int lastMonth = monthlyPrefs.getInt("lastMonth", -1);

        // --- MONTHLY RESET (30 days) ---
        if (cal.get(Calendar.DAY_OF_MONTH) == 1 && currentMonth != lastMonth) {
            Calendar monthStart = (Calendar) cal.clone();
            monthStart.add(Calendar.DAY_OF_YEAR, -30); // last 30 days including today
            String monthStartStr = sdf.format(monthStart.getTime());

            new Thread(() -> expenseDao.resetMonthlyExpenses(monthStartStr, todayStr)).start();

            monthlyPrefs.edit().putInt("lastMonth", currentMonth).apply();
            runOnUiThread(() -> Toast.makeText(this, "Monthly reset done!", Toast.LENGTH_SHORT).show());
        }

        // --- WEEKLY RESET (7 days) ---
       /* if (cal.get(Calendar.DAY_OF_WEEK) == Calendar.MONDAY && currentWeek != lastWeek) {
            Calendar weekStart = (Calendar) cal.clone();
            weekStart.add(Calendar.DAY_OF_YEAR, -6); // last 7 days including today
            String weekStartStr = sdf.format(weekStart.getTime());

            new Thread(() -> expenseDao.resetWeeklyExpenses(weekStartStr, todayStr)).start();

            weeklyPrefs.edit().putInt("lastWeekOfYear", currentWeek).apply();
            runOnUiThread(() -> Toast.makeText(this, "Weekly reset done!", Toast.LENGTH_SHORT).show());
        }   */

        // Initialize views
        drawerLayout = findViewById(R.id.drawer_layout);
        NavigationView navigationView = findViewById(R.id.nav_view);
        Toolbar toolbar = findViewById(R.id.toolbar);
        RecyclerView recyclerView = findViewById(R.id.recyclerView);
        inputTitle = findViewById(R.id.inputTitle);
        inputAmount = findViewById(R.id.inputAmount);
        Button addButton = findViewById(R.id.addButton);
        totalText = findViewById(R.id.totalText);

        // Toolbar & Drawer
        setSupportActionBar(toolbar);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawerLayout, toolbar,
                R.string.drawer_open, R.string.drawer_close
        );
        drawerLayout.addDrawerListener(toggle);
        toggle.syncState();

        // RecyclerView & Adapter
        adapter = new ExpenseAdapter(new ArrayList<>());
        recyclerView.setAdapter(adapter);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        // Add expense
        addButton.setOnClickListener(v -> {
            String title = inputTitle.getText().toString().trim();
            String amountStr = inputAmount.getText().toString().trim();
            if (!title.isEmpty() && !amountStr.isEmpty()) {
                double amount = Double.parseDouble(amountStr);
                String today = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
                        .format(Calendar.getInstance().getTime());
                new Thread(() -> expenseDao.insert(new Expense(title, amount, today))).start();
                inputTitle.setText("");
                inputAmount.setText("");
            }
        });

        // Delete expense
        adapter.setOnDeleteClickListener(expense -> new AlertDialog.Builder(this)
                .setTitle("Delete Expense")
                .setMessage("Are you sure you want to delete this expense?")
                .setPositiveButton("Yes", (dialog, which) ->
                        new Thread(() -> expenseDao.delete(expense)).start())
                .setNegativeButton("Cancel", null)
                .show());

        // Drawer item selection
        navigationView.setNavigationItemSelectedListener(item -> {
            int id = item.getItemId();
            if (id == R.id.nav_daily) loadDailyExpenses();
          //  else if (id == R.id.nav_weekly) loadWeeklyExpenses();
            else if (id == R.id.nav_monthly) loadMonthlyExpenses();
            drawerLayout.closeDrawer(GravityCompat.START);
            return true;
        });

        // Default view
        loadDailyExpenses();
    }

    private String getToday() {
        return new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
                .format(Calendar.getInstance().getTime());
    }

    private void loadDailyExpenses() {
        String today = getToday();
        expenseDao.getTodayExpenses(today).observe(this, this::updateExpenses);
    }

 /*   private void loadWeeklyExpenses() {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_YEAR, -7);
        String weekAgo = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
                .format(cal.getTime());
        expenseDao.getExpensesBetween(weekAgo, getToday())
                .observe(this, this::updateExpenses);
    } */

    private void loadMonthlyExpenses() {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_YEAR, -30);
        String monthAgo = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
                .format(cal.getTime());
        expenseDao.getExpensesBetween(monthAgo, getToday())
                .observe(this, this::updateExpenses);
    }

    private void updateExpenses(List<Expense> expenses) {
        adapter.setExpenses(expenses);
        double total = 0;
        for (Expense e : expenses) total += e.getAmount();
        totalText.setText(String.format(Locale.getDefault(), "Total: ₹%.2f", total));
    }
}

