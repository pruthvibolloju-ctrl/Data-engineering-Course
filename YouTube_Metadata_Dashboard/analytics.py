import pandas as pd

def calculate_metrics(df):
    total_views = df["views"].sum()
    
    df["engagement_rate"] = ((df["likes"] + df["comments"]) / df["views"]) * 100
    
    avg_engagement = df["engagement_rate"].mean()

    median_engagement = df["engagement_rate"].median()
    
    top_videos = df.sort_values(by="views", ascending=False).head(5)
    
    category_analysis = df.groupby("category")["views"].sum().reset_index()
    
    return total_views, avg_engagement, median_engagement, top_videos, category_analysis