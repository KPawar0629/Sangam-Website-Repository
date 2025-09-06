package com.sangam.sangam.repo;

import com.sangam.sangam.model.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;
import java.util.Optional;

public interface UserRepository extends MongoRepository<User, String> {

    List<User> findByFullName(String userName);

    Optional<User> findByEmail(String email);

    Optional<User> findByUserId(String userId);

    Optional<User> findByAuthToken(String token);
}
