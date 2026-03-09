import streamlit as st
import pandas as pd
from database import create_table, add_video, fetch_videos, delete_video
from analytics import calculate_metrics
st.set_page_config(
    page_title="YouTube Metadata Intelligence",
    page_icon="📊",
    layout="wide"
)

# Create DB table
create_table()

st.markdown("""
# 📊 YouTube Metadata Intelligence Dashboard
Analyze video performance, engagement trends, and content insights.
""")

# Sidebar Form
st.sidebar.subheader("Upload CSV")

uploaded_file = st.sidebar.file_uploader("Upload CSV File", type=["csv"])

if uploaded_file is not None:
    csv_df = pd.read_csv(uploaded_file)

    for _, row in csv_df.iterrows():
        data = (
            row["video_id"],
            row["title"],
            row["channel_name"],
            row["category"],
            int(row["views"]),
            int(row["likes"]),
            int(row["comments"]),
            int(row["duration"]),
            row["upload_date"]
        )
        try:
            add_video(data)
        except:
            pass  # skip duplicates

    st.sidebar.success("CSV Uploaded Successfully!")

video_id = st.sidebar.text_input("Video ID")
title = st.sidebar.text_input("Title")
channel = st.sidebar.text_input("Channel Name")
category = st.sidebar.text_input("Category")
views = st.sidebar.number_input("Views", min_value=0)
likes = st.sidebar.number_input("Likes", min_value=0)
comments = st.sidebar.number_input("Comments", min_value=0)
duration = st.sidebar.number_input("Duration (seconds)", min_value=0)
upload_date = st.sidebar.date_input("Upload Date")

if st.sidebar.button("Add Video"):
    data = (video_id, title, channel, category, views, likes, comments, duration, str(upload_date))
    add_video(data)
    st.sidebar.success("Video Added Successfully!")

# Fetch Data
rows = fetch_videos()

if rows:
    df = pd.DataFrame(rows, columns=[
        "id", "video_id", "title", "channel_name",
        "category", "views", "likes", "comments",
        "duration", "upload_date"
    ])
    df["upload_date"] = pd.to_datetime(df["upload_date"])
    st.subheader("All Videos")
    st.dataframe(df)

    # Analytics
    total_views, avg_engagement, median_engagement, top_videos, category_analysis = calculate_metrics(df)

    tab1, tab2, tab3 = st.tabs(["📊 Overview", "📈 Correlation", "🏆 Ranking"])
    with tab1:    
        st.subheader("📈 Key Performance Indicators")
        col1, col2, col3, col4 = st.columns(4)
        col1.metric("Total Videos", len(df))
        col2.metric("Total Views", f"{total_views:,}")
        col3.metric("Avg Engagement (%)", round(avg_engagement, 2)) 
        col4.metric("Median Engagement (%)", round(median_engagement, 2))
        
        st.subheader("Top Performing Videos")
        st.dataframe(top_videos)
        
        st.subheader("📊 Category Performance")
        category_views = df.groupby("category")["views"].sum().reset_index()
        st.bar_chart(category_views.set_index("category"))

        st.subheader("📅 Time-Based Performance")
        time_analysis = df.groupby("upload_date")["views"].sum().reset_index()
        st.line_chart(time_analysis.set_index("upload_date"))

        st.subheader("🏆 Channel Comparison")
        channel_analysis = df.groupby("channel_name")["views"].sum().reset_index()
        st.bar_chart(channel_analysis.set_index("channel_name"))

    with tab2:
        st.subheader("📊 Duration vs Views Correlation")
        st.scatter_chart(df[["duration", "views"]])
        correlation = df["duration"].corr(df["views"])
        st.write(f"Correlation between Duration and Views: {round(correlation, 3)}")
    with tab3:
        st.subheader("🥇 Video Ranking System")
        df["rank"] = df["views"].rank(ascending=False)
        ranking_df = df.sort_values("rank")
        st.dataframe(ranking_df[["title", "views", "rank"]])

    # Delete Option
    st.subheader("Delete Video")
    delete_id = st.text_input("Enter Video ID to Delete")
    if st.button("Delete"):
            delete_video(delete_id)
            st.success("Video Deleted Successfully!")
    else:
            st.info("No videos available. Add some from sidebar.")