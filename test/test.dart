
import 'dart:html';

void main() {
  final List<String> wordPool = [
    'привет',
    'мир',
    'это',
    'тест',
    'на',
    'скорость',
    'печати',
    'проверь',
    'свою',
    'удачи',
    'случайная',
    'фраза',
    'для',
    'тренировки',
    'пусть',
    'будет',
    'с',
    'тобой',
    'dart',
    'мощная',
    'вещь',
    'никогда',
    'не',
    'поздно',
    'начать',
    'каждый',
    'день',
    'лучше',
    'чем',
    'вчера',
    'быстро',
    'правильно',
    'внимательно',
    'работай',
    'учись',
    'развивайся',
    'достигай',
    'цели',
    'мечтай',
    'действуй',
    'пиши',
    'код',
    'решай',
    'задачи',
    'размышляй',
    'анализируй',
    'создавай',
    'вдохновляй',
    'делись',
    'знаниями',
  ];

  wordPool.shuffle();
  final List<String> testWords = wordPool.take(30).toList();

  int currentWordIndex = 0;
  int? startTime;
  bool finished = false;
  int errorCount = 0;
  int totalTypedChars = 0;

  final Set<int> correctWords = {};
  final Set<int> errorWords = {};

  final List<String> userInputs = [];

  document.body!.style.backgroundColor = '#111';
  document.body!.style.color = '#fff';

  final heading = HeadingElement.h1()
    ..text = 'Тест скоропечатания'
    ..style.textAlign = 'center'
    ..style.color = '#fff';

  final phrase = DivElement()
    ..style.fontSize = '22px'
    ..style.textAlign = 'center'
    ..style.marginTop = '20px'
    ..style.color = '#fff'
    ..style.display = 'flex'
    ..style.flexDirection = 'column'
    ..style.alignItems = 'center'
    ..style.justifyContent = 'center';

  final input = TextInputElement()
    ..placeholder = testWords[0]
    ..style.width = '300px'
    ..style.display = 'block'
    ..style.margin = '30px auto 0 auto'
    ..style.fontSize = '20px'
    ..style.backgroundColor = '#222'
    ..style.color = '#fff'
    ..style.border = '1px solid #555'
    ..style.textAlign = 'center';

  final result = ParagraphElement()
    ..style.fontSize = '18px'
    ..style.textAlign = 'center'
    ..style.marginTop = '20px'
    ..style.color = '#fff';

  final errorInfo = ParagraphElement()
    ..style.fontSize = '16px'
    ..style.textAlign = 'center'
    ..style.marginTop = '10px'
    ..style.color = '#e74c3c';

  final info = ParagraphElement()
    ..style.fontSize = '16px'
    ..style.textAlign = 'center'
    ..style.marginTop = '30px'
    ..style.color = '#aaa'
    ..style.whiteSpace = 'pre-line'
    ..text = '''
Работа с данными (ввод информации) — 180–240 знаков в минуту.
Журналисты и копирайтеры — 200–260 знаков в минуту.
Секретари и администраторы — 220–300 знаков в минуту.
Профессиональные наборщики текста — 280–350 знаков в минуту.
Стенографисты — 300+ знаков в минуту.''';

  void updatePhrase() {
    phrase.children.clear();
    for (int row = 0; row < (testWords.length / 5).ceil(); row++) {
      final rowDiv = DivElement()
        ..style.display = 'flex'
        ..style.justifyContent = 'center'
        ..style.marginBottom = '8px';
      for (int col = 0; col < 5; col++) {
        int i = row * 5 + col;
        if (i >= testWords.length) break;
        final span = SpanElement()..text = testWords[i];

        if (i < currentWordIndex) {
          if (correctWords.contains(i)) {
            span.style.color = '#27ae60';
          } else if (errorWords.contains(i)) {
            span.style.color = '#e74c3c';
          } else {
            span.style.color = '#444';
          }
        } else if (i == currentWordIndex) {
          final value = input.value!.trim();
          if (value == testWords[i]) {
            span.style.color = '#27ae60';
          } else if (value.length == testWords[i].length &&
              value != testWords[i]) {
            span.style.color = '#e74c3c';
          } else {
            span.style.color = '#b388ff';
          }
          span.style.fontWeight = 'bold';
          span.style.textDecoration = 'underline';
        } else {
          span.style.color = '#fff';
        }
        span.style.marginRight = '10px';
        rowDiv.append(span);
      }
      phrase.append(rowDiv);
    }
    errorInfo.text = 'Ошибок: $errorCount';
  }

  updatePhrase();

  input.onFocus.listen((_) {
    if (startTime == null && !finished) {
      startTime = DateTime.now().millisecondsSinceEpoch;
    }
  });

  input.onInput.listen((_) {
    if (finished || currentWordIndex >= testWords.length) return;

    final currentWord = testWords[currentWordIndex];
    final value = input.value?.trim() ?? '';

    if (value == currentWord) {
      correctWords.add(currentWordIndex);
      errorWords.remove(currentWordIndex);
      totalTypedChars += value.length;
      userInputs.add(value);
      currentWordIndex++;
      input.value = '';
      if (currentWordIndex < testWords.length) {
        input.placeholder = testWords[currentWordIndex];
        updatePhrase();
      } else {
        final endTime = DateTime.now().millisecondsSinceEpoch;
        final seconds = ((endTime - (startTime ?? endTime)) / 1000);
        final znm = ((totalTypedChars / seconds) * 60).round();
        result.text =
            'Поздравляем! Время: ${seconds.toStringAsFixed(2)} секунд. Скорость: $znm зн./мин.';
        input.disabled = true;
        finished = true;
        updatePhrase();
        document.body!.append(errorInfo);
        document.body!.append(info);

        final userResultTitle = ParagraphElement()
          ..text = 'Ваш ввод:'
          ..style.fontSize = '20px'
          ..style.textAlign = 'center'
          ..style.marginTop = '20px'
          ..style.color = '#fff';

        final userResultBlock = DivElement()
          ..style.fontSize = '28px'
          ..style.textAlign = 'center'
          ..style.marginTop = '30px'
          ..style.color = '#fff';

        for (int i = 0; i < userInputs.length; i += 5) {
          final row = userInputs.skip(i).take(5).join(' ');
          final rowDiv = DivElement()
            ..text = row
            ..style.marginBottom = '8px';
          userResultBlock.append(rowDiv);
        }

        document.body!.append(userResultTitle);
        document.body!.append(userResultBlock);
      }
    } else if (value.length == currentWord.length && value != currentWord) {
      errorWords.add(currentWordIndex);
      correctWords.remove(currentWordIndex);
      errorCount++;
      totalTypedChars += value.length;
      userInputs.add(value);
      currentWordIndex++;
      input.value = '';
      if (currentWordIndex < testWords.length) {
        input.placeholder = testWords[currentWordIndex];
        updatePhrase();
      } else {
        final endTime = DateTime.now().millisecondsSinceEpoch;
        final seconds = ((endTime - (startTime ?? endTime)) / 1000);
        final znm = ((totalTypedChars / seconds) * 60).round();
        result.text =
            'Поздравляем! Время: ${seconds.toStringAsFixed(2)} секунд. Скорость: $znm зн./мин.';
        input.disabled = true;
        finished = true;
        updatePhrase();
        document.body!.append(errorInfo);
        document.body!.append(info);

        final userResultTitle = ParagraphElement()
          ..text = 'Ваш ввод:'
          ..style.fontSize = '20px'
          ..style.textAlign = 'center'
          ..style.marginTop = '20px'
          ..style.color = '#fff';

        final userResultBlock = DivElement()
          ..style.fontSize = '28px'
          ..style.textAlign = 'center'
          ..style.marginTop = '30px'
          ..style.color = '#fff';

        for (int i = 0; i < userInputs.length; i += 5) {
          final row = userInputs.skip(i).take(5).join(' ');
          final rowDiv = DivElement()
            ..text = row
            ..style.marginBottom = '8px';
          userResultBlock.append(rowDiv);
        }

        document.body!.append(userResultTitle);
        document.body!.append(userResultBlock);
      }
    } else {
      updatePhrase();
    }
  });

  input.onKeyDown.listen((KeyboardEvent e) {
    if (finished || currentWordIndex >= testWords.length) return;
    if (e.key == ' ' || e.key == 'Enter') {
      e.preventDefault();

      final currentWord = testWords[currentWordIndex];
      final value = input.value?.trim() ?? '';

      if (value == currentWord) {
        correctWords.add(currentWordIndex);
        errorWords.remove(currentWordIndex);
      } else if (value.length != currentWord.length) {
        errorWords.add(currentWordIndex);
        correctWords.remove(currentWordIndex);
        errorCount++;
      } else {
        errorWords.add(currentWordIndex);
        correctWords.remove(currentWordIndex);
        errorCount++;
      }

      currentWordIndex++;
      input.value = '';
      if (currentWordIndex < testWords.length) {
        input.placeholder = testWords[currentWordIndex];
        updatePhrase();
      } else {
        final endTime = DateTime.now().millisecondsSinceEpoch;
        final seconds = ((endTime - (startTime ?? endTime)) / 1000);
        final znm = ((totalTypedChars / seconds) * 60).round();
        result.text =
            'Поздравляем! Время: ${seconds.toStringAsFixed(2)} секунд. Скорость: $znm зн./мин.';
        input.disabled = true;
        finished = true;
        updatePhrase();
        document.body!.append(errorInfo);
        document.body!.append(info);
      }
    }
  });

  document.body!
    ..children.clear()
    ..append(heading)
    ..append(phrase)
    ..append(input)
    ..append(result)
    ..append(errorInfo);
}
