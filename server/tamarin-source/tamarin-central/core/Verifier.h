/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is [Open Source Virtual Machine.].
 *
 * The Initial Developer of the Original Code is
 * Adobe System Incorporated.
 * Portions created by the Initial Developer are Copyright (C) 2004-2006
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Adobe AS3 Team
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */

#ifndef __avmplus_Verifier__
#define __avmplus_Verifier__


namespace avmplus
{
	/**
	 * We are simulating the effect that each instruction has on the stack
	 * frame state.  Type information originates from the following sources:
	 *    - formal parameter types of the curent method
	 *    - traits of objects we manipulate
	 *    - types of slots in traits
	 *    - return values of methods we call
	 *    - push (constant) instructions
	 *    - check (cast) instructions
	 *    - results of opcodes that produce known types
	 *
	 * When we have branch instructions, we merge the frame state at the end
	 * of the block with the starting frame state of the target block.
	 * incompatible frame states cause verify errors.
	 */

	#if defined AVMPLUS_MIR
	class CodegenMIR;
	#elif defined FEATURE_NANOJIT
	class CodegenLIR;
	#endif

	class Verifier
	{
	public:

		#if defined AVMPLUS_MIR
		CodegenMIR *jit;
		#endif // AVMPLUS_MIR

		#ifdef FEATURE_NANOJIT
		CodegenLIR *jit;
		#endif

		#ifdef AVMPLUS_WORD_CODE
		WordcodeTranslator *translator;
		int num_caches;			// number of entries in 'caches'
		int next_cache;			// next free entry in 'caches'
		uint32_t* caches;			// entry i has an imm30 value that represents the multiname whose entry in the MethodEnv's lookup cache is 'i'
		#endif
		
		AvmCore *core;
		SortedIntMap<FrameState*>* blockStates;
		FrameState *state;

		int max_scope;
		int max_stack;
		int stackBase;	 // same as info->local_count + max_scope

		union {
			int scopeBase;
			int local_count;
		};

		int frameSize;
		int code_length;
		const byte* code_pos;
		const byte* exceptions_pos;

		MethodInfo *info;
		PoolObject *pool;
		int labelCount;

		Verifier(MethodInfo *info, Toplevel* toplevel
#ifdef AVMPLUS_VERBOSE
			, bool secondTry=false
#endif
			);
		~Verifier();

		/**
		 * Verifies the method specified by info.  If verification fails,
		 * an exception will be thrown, of type VerifyError.
		 * @param info the method to verify
		 */
#if defined AVMPLUS_MIR
		void verify(CodegenMIR* volatile);
#elif defined FEATURE_NANOJIT
		void verify(CodegenLIR* volatile);
#else
		void verify();
#endif
		FrameState* getFrameState(sintptr targetpc);

	private:
		Toplevel* toplevel;
		#ifdef FEATURE_BUFFER_GUARD
		#ifdef AVMPLUS_MIR
		GrowthGuard *growthGuard;
		#endif
		#endif

		FrameState* newFrameState();
		Value& checkLocal(int local);
		AbstractFunction*  checkDispId(Traits* traits, uint32_t disp_id);
		AbstractFunction*  checkMethodInfo(uint32_t method_id);
		Traits*            checkClassInfo(uint32_t class_id);
		Traits*            checkTypeName(uint32_t name_index);
		void verifyFailed(int errorID, Stringp a1=0, Stringp a2=0, Stringp a3=0) const;
		void checkTarget(const byte* target);
		Atom checkCpoolOperand(uint32_t index, int requiredAtomType);
		void checkConstantMultiname(uint32_t index, Multiname &m);
		bool canAssign(Traits* lhs, Traits* rhs) const;
		Traits* checkSlot(Traits* traits, int slot_id);
		Traits* findCommonBase(Traits* t1, Traits* t2);
		void emitCoerceArgs(AbstractFunction* m, int argc, bool isctor=false);
		void printValue(Value& v);
		Traits* readBinding(Traits* traits, Binding b);
		void checkEarlySlotBinding(Traits* traits);
		Traits* peekType(Traits* requiredType, int n=1);
		Traits* emitCoerceSuper(int index);
		void checkCallMultiname(AbcOpcode opcode, Multiname* multiname) const;
		void checkPropertyMultiname(uint32_t &depth, Multiname& multiname);
		void parseExceptionHandlers();
		void checkStack(uint32_t pop, uint32_t push);
		void checkStackMulti(uint32_t pop, uint32_t push, Multiname* m);

		void emitCoerce(Traits* target, int i);
		void emitToString(AbcOpcode opcode, int index);
		#if defined AVMPLUS_MIR || defined FEATURE_NANOJIT
		void emitCheckNull(int index);
		#endif
		void emitCompare(AbcOpcode opcode);
		void emitFindProperty(AbcOpcode opcode, Multiname& multiname, uint32_t imm30);
		void emitGetProperty(Multiname &multiname, int n, uint32_t imm30);
		void emitGetGlobalScope();
		void emitGetOuterScope(int scope_idx);
		void emitGetSlot(int slot);
		void emitSetSlot(int slot);
		void emitSwap();
        void emitNip();

		void emitCallproperty(AbcOpcode opcode, int& sp, Multiname& multiname, uint32_t multiname_index, uint32_t argc);
		bool emitCallpropertyMethod(AbcOpcode opcode, Traits* t, Binding b, Multiname& multiname, uint32_t multiname_index, uint32_t argc);
		bool emitCallpropertySlot(AbcOpcode opcode, int& sp, Traits* t, Binding b, uint32_t argc);
#ifdef AVMPLUS_WORD_CODE
		uint32_t allocateCacheSlot(uint32_t imm30);
#endif
		Binding findMathFunction(TraitsBindingsp math, const Multiname& name, Binding b, int argc);
		Binding findStringFunction(TraitsBindingsp string, const Multiname& name, Binding b, int argc);

		#ifdef AVMPLUS_VERBOSE
	public:
		bool verbose;
		bool secondTry;
		void showState(FrameState* state, const byte* pc, bool unreachable);
		void verifyWarn(int errorId, ...);
		#endif
    };
}

namespace nanojit {
    class Fragment;
    struct GuardRecord {
        int calldepth;
        Fragment *from, *target;
        void *jmp, *origTarget;
        GuardRecord *next, *outgoing;
    };
    #define GuardRecordSize(r) sizeof(GuardRecord)

    struct SideExit {
        int sid;
        Fragment *target;
    };
    #define SideExitSize(x) sizeof(SideExit)
}

#endif /* __avmplus_Verifier__ */
