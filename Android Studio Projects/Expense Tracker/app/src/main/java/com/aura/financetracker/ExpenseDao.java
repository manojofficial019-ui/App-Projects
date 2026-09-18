package com.aura.financetracker;

import androidx.lifecycle.LiveData;
import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;

import java.util.List;

@Dao
public interface ExpenseDao {

    // Insert a new expense
    @Insert
    void insert(Expense expense);

    // Delete a single expense
    @Delete
    void delete(Expense expense);

    // Get expenses for today
    @Query("SELECT * FROM expenses WHERE date = :today")
    LiveData<List<Expense>> getTodayExpenses(String today);

    // Get expenses between two dates (for weekly/monthly viewing)
    @Query("SELECT * FROM expenses WHERE date BETWEEN :start AND :end")
    LiveData<List<Expense>> getExpensesBetween(String start, String end);

    // Reset last 7 days (weekly reset)
  //  @Query("DELETE FROM expenses WHERE date BETWEEN :start AND :end")
    //void resetWeeklyExpenses(String start, String end);

    // Reset last 30 days (monthly reset)
    @Query("DELETE FROM expenses WHERE date BETWEEN :start AND :end")
    void resetMonthlyExpenses(String start, String end);
}
