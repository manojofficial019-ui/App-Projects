package com.aura.financetracker.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.aura.financetracker.Expense;
import com.aura.financetracker.R;

import java.util.List;

public class ExpenseAdapter extends RecyclerView.Adapter<ExpenseAdapter.ExpenseViewHolder> {

    private List<Expense> expenses;
    private OnDeleteClickListener deleteClickListener;

    // Constructor
    public ExpenseAdapter(List<Expense> expenses) {
        this.expenses = expenses;
    }

    // Update the expenses list
    public void setExpenses(List<Expense> expenses) {
        this.expenses = expenses;
        notifyDataSetChanged();
    }

    // Set the delete listener
    public void setOnDeleteClickListener(OnDeleteClickListener listener) {
        this.deleteClickListener = listener;
    }

    @NonNull
    @Override
    public ExpenseViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_expense, parent, false);
        return new ExpenseViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull ExpenseViewHolder holder, int position) {
        Expense expense = expenses.get(position);
        holder.titleText.setText(expense.getTitle());
        holder.amountText.setText("₹" + expense.getAmount());
        holder.dateText.setText(expense.getDate());

        // Long press to delete
        holder.itemView.setOnLongClickListener(v -> {
            if (deleteClickListener != null) {
                deleteClickListener.onDeleteClick(expense);
            }
            return true; // indicates the long press is consumed
        });
    }

    @Override
    public int getItemCount() {
        return expenses.size();
    }

    // ViewHolder
    static class ExpenseViewHolder extends RecyclerView.ViewHolder {
        TextView titleText, amountText, dateText;

        ExpenseViewHolder(@NonNull View itemView) {
            super(itemView);
            titleText = itemView.findViewById(R.id.titleText);
            amountText = itemView.findViewById(R.id.amountText);
            dateText = itemView.findViewById(R.id.dateTimeText); // match your layout id
        }
    }

    // Delete interface
    public interface OnDeleteClickListener {
        void onDeleteClick(Expense expense);
    }
}
