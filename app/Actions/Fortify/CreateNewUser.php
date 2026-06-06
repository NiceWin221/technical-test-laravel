<?php

namespace App\Actions\Fortify;

use App\Concerns\PasswordValidationRules;
use App\Concerns\ProfileValidationRules;
use App\Models\User;
use App\Models\Tenant;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use Laravel\Fortify\Contracts\CreatesNewUsers;

class CreateNewUser implements CreatesNewUsers
{
    use PasswordValidationRules, ProfileValidationRules;

    /**
     * Validate and create a newly registered user.
     *
     * @param  array<string, string>  $input
     */
    public function create(array $input): User
    {
        Validator::make($input, [
            ...$this->profileRules(),
            'password' => $this->passwordRules(),
            'registration_type' => ['required', 'string', 'in:create,join'],
            'company_name' => ['required_if:registration_type,create', 'nullable', 'string', 'max:255'],
            'referral_code' => ['required_if:registration_type,join', 'nullable', 'string'],
        ])->validate();

        $tenantId = null;
        $role = 'staff';
        $isAccepted = false;

        if ($input['registration_type'] === 'create') {
            $tenant = Tenant::create([
                'name' => $input['company_name'],
                'referral_code' => strtoupper(Str::random(8)),
            ]);
            $tenantId = $tenant->id;
            $role = 'owner';
            $isAccepted = true;
        } else {
            $tenant = Tenant::where('referral_code', $input['referral_code'])->first();
            if (!$tenant) {
                throw ValidationException::withMessages([
                    'referral_code' => ['The provided referral code is invalid.'],
                ]);
            }
            $tenantId = $tenant->id;
        }

        return User::create([
            'name' => $input['name'],
            'email' => $input['email'],
            'role' => $role,
            'is_accepted' => $isAccepted,
            'tenant_id' => $tenantId,
            'password' => $input['password'],
        ]);
    }
}
