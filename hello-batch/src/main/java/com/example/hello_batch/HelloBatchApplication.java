package com.example.hello_batch;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class HelloBatchApplication implements CommandLineRunner {

    private final Counter executions;   // métrica propia

    public HelloBatchApplication(MeterRegistry registry) {
        executions = Counter.builder("hello_batch_executions_total")
                            .description("Veces que se ejecuta el batch")
                            .register(registry);
    }

    public static void main(String[] args) {
        SpringApplication.run(HelloBatchApplication.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        System.out.println("→ Arranca batch");
        executions.increment();          
        Thread.sleep(120_000);            
        System.out.println("→ Fin batch");
    }
}
