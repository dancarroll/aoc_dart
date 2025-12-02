import 'package:aoc_shared/shared.dart';
import 'package:aoc_2024/day23/part_1.dart' as part1;
import 'package:aoc_2024/day23/part_2.dart' as part2;
import 'package:aoc_2024/day23/part_2bk.dart' as part2bk;
import 'package:test/test.dart';

void main() {
  final day = Day.day23;

  group('sample data', tags: 'sample-data', () {
    final resources = Resources.sample;
    final file = resources.fileForCurrentYear(day);

    test('part1', () async {
      expect(await part1.calculate(file), 7);
    });

    test('part2', () async {
      expect(await part2.calculate(file), 'co,de,ka,ta');
    });

    test('part2 with Bron–Kerbosch', () async {
      expect(await part2bk.calculate(file), 'co,de,ka,ta');
    });
  });

  group('real data', tags: 'real-data', () {
    final resources = Resources.real;
    final file = resources.fileForCurrentYear(day);

    test('part1', () async {
      expect(await part1.calculate(file), 1151);
    });

    test('part2', () async {
      expect(
        await part2.calculate(file),
        'ar,cd,hl,iw,jm,ku,qo,rz,vo,xe,xm,xv,ys',
      );
    });

    test('part2 with Bron–Kerbosch', () async {
      expect(
        await part2bk.calculate(file),
        'ar,cd,hl,iw,jm,ku,qo,rz,vo,xe,xm,xv,ys',
      );
    });
  });
}
