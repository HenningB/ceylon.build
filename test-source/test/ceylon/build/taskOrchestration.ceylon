import ceylon.build { Task, findTasksToExecute, linearize, reduce }
import ceylon.test { assertEquals }
import ceylon.collection { HashSet }

void testTasksOrchestration() {
    testFindTasksToExecute();
    testTasksLinearization();
    testTasksReduction();
}

void testFindTasksToExecute() {
    value writer = MockWriter();
    Task a = createTestTask("a");
    Task b = createTestTask("b");
    assertEquals([], findTasksToExecute(HashSet({ a }), [], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertEquals([a], findTasksToExecute(HashSet({ a }), ["a"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertEquals([], findTasksToExecute(HashSet({ a }), ["a", "b"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals(["# task 'b' not found, stopping"], writer.errorMessages);
    writer.clear();
    assertEquals([a, b], findTasksToExecute(HashSet({ a, b }), ["a", "b"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertEquals([a, b], findTasksToExecute(HashSet({ a, b }), ["a", "b", "-Dfoo=bar"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertEquals([a], findTasksToExecute(HashSet({ a, b }), ["a"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    Task c = createTestTask("c");
    Task d = createTestTask("d", [c]);
    assertEquals([d], findTasksToExecute(HashSet({ c, d }), ["d"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
}

void testTasksLinearization() {
    Task a = createTestTask("a");
    Task b = createTestTask("b", [a]);
    Task c = createTestTask("c", [b]);
    Task d = createTestTask("d", [b, a]);
    assertEquals([a], linearize(a, HashSet({ a })));
    assertEquals([a, b], linearize(b, HashSet({ a, b })));
    assertEquals([a, b, c], linearize(c, HashSet({ a, c, b })));
    assertEquals([a, b, a, d], linearize(d, HashSet ({ a, b, c, d })));
}

void testTasksReduction() {
    Task a = createTestTask("a");
    Task b = createTestTask("b");
    Task c = createTestTask("c");
    assertEquals([], reduce([]));
    assertEquals([a], reduce([a]));
    assertEquals([a], reduce([a, a]));
    assertEquals([a, b], reduce([a, b]));
    assertEquals([b, a], reduce([b, a, b]));
    assertEquals([b, a, c], reduce([b, a, b, b, a, c, a, b]));
}