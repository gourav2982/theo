import 'package:theo/models/course_models.dart';

class CourseData {
  static CourseDetail getCourse() {
    return CourseDetail(
      title: "Technical Analysis Fundamentals",
      progress: 35,
      currentModule: "Introduction to Candlestick Patterns",
      lessons: [
        Lesson(
          id: 1,
          title: "Understanding Candlestick Charts",
          type: LessonType.video,
          duration: "8:24",
          completed: true,
        ),
        Lesson(
          id: 2,
          title: "Basic Candlestick Patterns",
          type: LessonType.video,
          duration: "12:15",
          completed: false,
        ),
        Lesson(
          id: 3,
          title: "Single Candlestick Patterns",
          type: LessonType.text,
          duration: "5 min read",
          completed: false,
        ),
        Lesson(
          id: 4,
          title: "Multiple Candlestick Patterns",
          type: LessonType.text,
          duration: "8 min read",
          completed: false,
        ),
        Lesson(
          id: 5,
          title: "Knowledge Check: Candlestick Patterns",
          type: LessonType.quiz,
          duration: "5 questions",
          completed: false,
        ),
      ],
    );
  }

  static LessonContent getLessonContent() {
    return LessonContent(
      title: "Basic Candlestick Patterns",
      videoUrl: "#", // In a real app, this would be the actual video URL
      text: """
        <h2>Understanding Basic Candlestick Patterns</h2>
        <p>Candlestick patterns are specific formations on candlestick charts that traders use to identify potential market movements. They can signal trend reversals, continuations, or market indecision.</p>
        
        <h3>Bullish Patterns</h3>
        <p>Bullish patterns suggest that prices may rise in the future. Some common bullish patterns include:</p>
        <ul>
          <li><strong>Hammer</strong> - A single candlestick with a small body at the top and a long lower shadow. It indicates a potential reversal from a downtrend.</li>
          <li><strong>Bullish Engulfing</strong> - A two-candlestick pattern where a large bullish candle completely engulfs the previous bearish candle.</li>
          <li><strong>Morning Star</strong> - A three-candlestick pattern showing a potential reversal from a downtrend.</li>
        </ul>
        
        <h3>Bearish Patterns</h3>
        <p>Bearish patterns suggest that prices may fall in the future. Some common bearish patterns include:</p>
        <ul>
          <li><strong>Hanging Man</strong> - Similar to the hammer but appears in an uptrend, signaling a potential reversal downward.</li>
          <li><strong>Bearish Engulfing</strong> - A two-candlestick pattern where a large bearish candle completely engulfs the previous bullish candle.</li>
          <li><strong>Evening Star</strong> - A three-candlestick pattern showing a potential reversal from an uptrend.</li>
        </ul>
        
        <h3>Interpreting Patterns</h3>
        <p>When analyzing candlestick patterns, it's important to consider:</p>
        <ul>
          <li>The overall market context and trend</li>
          <li>Volume confirmation</li>
          <li>Other technical indicators</li>
          <li>Support and resistance levels</li>
        </ul>
        
        <p>Remember that no pattern is 100% reliable. Always use candlestick patterns as part of a broader trading strategy.</p>
      """,
    );
  }
}